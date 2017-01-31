defmodule DataSanitiser.FileProcessor do
  @moduledoc """
  Handle the processing of a single file.

  This contains all that's needed to handle the generic case of processing a
  file, running checks on things and then finally executing the appropriate
  cleaning function for the specific file and data type.
  """

  alias DataSanitiser.Canonicaliser
  alias DataSanitiser.DateUtils
  alias DataSanitiser.OrganisationUtils
  alias DataSanitiser.TransparencyData.DataFile
  alias DataSanitiser.TransparencyData.MeetingRow

  import DataSanitiser.GeneralUtils, only: [
    log_error: 1,
    put_into_map_at: 3,
    trim_spaces_and_commas: 1
  ]

  @header_types %{
    "organisation" => :organisations,
    "minister" => :minister,
    "date" => :date,
    "reason" => :reason,
    "purpose" => :reason
  }

  @processing_steps [
    :check_file_exists,
    :check_has_single_data_type,
    :clean_file
  ]


  @doc """
  Read in a file, process its data and return it.

  Reads in the file specified in the `DataSanitiser.TransparencyData.DataFile`
  provided, process its rows and then return the original struct with the rows
  included.

  Processing is done by passing the data through a series of steps, as defined
  in @processing_steps.

  As long as even some data was able to be processed a tuple starting with `:ok`
  will be returned.

  Otherwise, if an error occurs that prevents the file being processed at all
  then a tuple starting with `:error` will be returned.
  """
  @spec process(DataFile.t) :: {:ok, DataFile.t} | {:error, atom, DataFile.t}
  def process(file_metadata) do
    case do_process(@processing_steps, file_metadata) do
      {:ok, file_metadata} ->
        {:ok, file_metadata}
      {:error, error, file_metadata} ->
        log_bad_file(error, file_metadata)
        {:error, error, file_metadata}
    end
  end


  # If we got to the end then we didn't hit a problem so return :ok
  @spec do_process([atom], DataFile.t) :: {:ok, DataFile.t}
                                        | {:error, atom, DataFile.t}
  defp do_process([], file_metadata), do: {:ok, file_metadata}

  defp do_process([:check_file_exists | remaining], file_metadata) do
    if File.exists?(file_metadata.filename) do
      do_process(remaining, file_metadata)
    else
      {:error, :not_found, file_metadata}
    end
  end

  defp do_process([:clean_file | remaining], file_metadata) do
    case clean_file(file_metadata) do
      {:ok, file_metadata} ->
        do_process(remaining, file_metadata)
      error ->
        error
    end
  end

  defp do_process([:check_has_single_data_type | remaining], file_metadata) do
    case file_metadata.data_type do
      :ambiguous ->
        {:error, :ambiguous_data_type, file_metadata}
      :nil ->
        {:error, :no_data_type, file_metadata}
      _ ->
        do_process(remaining, file_metadata)
    end
  end


  defmodule RowState do
    @moduledoc """
    Struct to store info needed whilst processing data.

    `previous_minister` represents the last minister name seen
    `data_positions` are which columns represent which data field.

    This state should be generic enough that it can be used no matter what
    type of data file is being processed.
    """
    defstruct previous_minister: :nil, data_positions: :nil
    @type t :: %RowState{
      previous_minister: String.t | :nil,
      data_positions: [atom] | :nil
    }
  end


  @doc """
  Read the data in from a file, clean it and return it.

  The `DataSanitiser.TransparencyData.DataFile` provided will either be
  returned in a tuple starting with `:ok` having had its `:rows` key populated
  with the cleaned data, or (if something went wrong), a tuple starting with
  `:error` and an error atom.

  Note: An error will only be returned if there's a problem with the file
  itself. If some of the rows are invalid then it will still attempt to return
  the data from any that were valid.
  """
  @spec clean_file(DataFile.t) :: {:ok, DataFile.t}
                                | {:error, atom, DataFile.t}
  def clean_file(file_metadata=%{data_type: :meetings}) do
    case DataFile.extract_data(file_metadata) do
      {:ok, data_stream} ->
        new_metadata = data_stream
                       |> clean_data(file_metadata)
                       |> put_into_map_at(file_metadata, :rows)
        {:ok, new_metadata}
      error ->
        error
    end
  end

  def clean_file(file_metadata) do
    {:error, :unsupported_data_type, file_metadata}
  end


  @doc """
  Clean up a data stream which has been read from a file.

  Currently only knows how to clean data from meetings files.
  """
  @spec clean_data(Enumerable.t, DataFile.t) :: Enumerable.t
  def clean_data(data_stream, file_metadata=%{data_type: :meetings}) do
    data_stream
    |> Stream.transform(:header, &(clean_meeting_row &1, &2, file_metadata))
    |> Stream.filter(&MeetingRow.is_valid?/1)
  end


  @spec clean_meeting_row(
          {[String.t], non_neg_integer},
          :header | RowState.t,
          DataFile.t
        ) :: {[MeetingRow.t], RowState.t}
           | {[{:error, atom, non_neg_integer}], RowState.t}
  defp clean_meeting_row(row, :header, _file_metadata) do
    # When dealing with a header row, try to extract the positions of columns
    # from the row and update the state with it.
    data_positions = meeting_data_positions_from_header row
    {
      [], # Don't add anything to the stream of row data
      %RowState{data_positions: data_positions}
    }
  end

  defp clean_meeting_row({row, row_index}, row_state, file_metadata) do
    case fetch_meeting_values_from_row(row, row_state) do
      %{minister: "", date: "", organisations: "", reason: ""} ->
        # Don't add anything to the stream if no data was put into any of the
        # columns
        {[], row_state}
      %{
        minister: minister,
        date: date,
        organisations: organisations,
        reason: reason
      } ->
        # If there's at least some data then process it into a MeetingRow
        # and add it to the stream.
        row = %MeetingRow{row: row_index}
              |> parse_and_insert_minister(String.trim(minister), row_state)
              |> parse_and_insert_date(date, file_metadata.year)
              |> parse_and_insert_reason(reason)
              |> parse_and_insert_organisations(organisations)
        {[row], Map.put(row_state, :previous_minister, row.minister)}
      _ ->
        if row_is_empty? row do
          # Don't add anything to the stream or state if the row is empty.
          {[], row_state}
        else
          # Add an error to the stream otherwise as we don't know how to handle
          # this row.
          {[{:error, :invalid_row, row_index}], row_state}
        end
    end
  end


  @spec meeting_data_positions_from_header(
          {[String.t], non_neg_integer}
        ) :: [:atom]
  defp meeting_data_positions_from_header({header_row, _}) do
    Enum.map header_row, &(extract_column_type String.trim(&1))
  end


  @spec extract_column_type(String.t) :: atom
  defp extract_column_type(""), do: :empty

  defp extract_column_type(header_value) do
    do_extract_column_type(header_value, Map.keys(@header_types))
  end


  @spec do_extract_column_type(String.t, [String.t]) :: atom
  # No match found so return `:unknown`
  defp do_extract_column_type(_header_value, []), do: :unknown

  defp do_extract_column_type(header_value, [type_key | remaining_types]) do
    # Check if the key at the head of the list is in the header string,
    # If so return the atom associated with that key, otherwise move on to the
    # next one.
    key_matches = header_value
                  |> String.downcase
                  |> String.contains?(type_key)
    if key_matches do
      @header_types[type_key]
    else
      do_extract_column_type(header_value, remaining_types)
    end
  end


  @spec fetch_meeting_values_from_row(
          [String.t], RowState.t
        ) :: %{required(atom) => String.t}
  defp fetch_meeting_values_from_row(row, row_state) do
    row_state.data_positions
    |> Enum.zip(row)
    |> Enum.into(%{})
  end


  @spec row_is_empty?([String.t]) :: boolean
  defp row_is_empty?(row), do: Enum.all? row, &(""  == String.trim &1)


  @spec parse_and_insert_minister(
          MeetingRow.t, String.t, RowState.t
        ) :: MeetingRow.t
  defp parse_and_insert_minister(
         row, "", %RowState{previous_minister: minister}
       ) do
    # If the current row has no minister value in it substitute in the last
    # one seen.

    minister
    |> clean_minister_name
    |> put_into_map_at(row, :minister)
  end

  defp parse_and_insert_minister(row, minister, _) do
    minister
    |> clean_minister_name
    |> put_into_map_at(row, :minister)
  end


  @spec clean_minister_name(String.t | :nil) :: String.t | :nil
  defp clean_minister_name(:nil), do: :nil
  defp clean_minister_name(minister) do
    # Normalises to some common name prefixes and suffixes by trimming
    # anything before or after them. Removes anything written inside brackets
    # as this is usually just extra info such as when they took up their role.
    # Also tidies up excess spaces and commas then returns a canonically cased
    # version.

    minister
    |> String.replace(~r{^.* Rt Hon}, "Rt Hon")
    |> String.replace(~r{ MP[ ,].*$}, " MP")
    |> String.replace(~r{\(.*\)}, "")
    |> trim_spaces_and_commas
    |> Canonicaliser.canonicalise
  end


  @spec parse_and_insert_reason(MeetingRow.t, String.t) :: MeetingRow.t
  defp parse_and_insert_reason(row, reason) do
    reason
    |> clean_reason
    |> put_into_map_at(row, :reason)
  end


  @spec clean_reason(String.t) :: String.t
  defp clean_reason(reason) do
    # For reasons we just trim excess whitespace/commas and then canonicalise
    # the case for easier comparison.

    reason
    |> trim_spaces_and_commas
    |> Canonicaliser.canonicalise
  end


  @spec parse_and_insert_date(
          MeetingRow.t, String.t, pos_integer
        ) :: MeetingRow.t
  defp parse_and_insert_date(row, date_string, default_year) do
    # Converts the date string to a tuple, then for now puts it in both the
    # start and end date entries.

    date_tuple = DateUtils.date_string_to_tuple(date_string, default_year)
    row
    |> Map.put(:start_date, date_tuple)
    |> Map.put(:end_date, date_tuple)
  end


  @spec parse_and_insert_organisations(MeetingRow.t, String.t) :: MeetingRow.t
  defp parse_and_insert_organisations(row, organisations_string) do
    organisations_string
    |> OrganisationUtils.parse_organisations
    |> put_into_map_at(row, :organisations)
  end


  @spec log_bad_file(atom, DataFile.t) :: :ok
  defp log_bad_file(:not_found, file_metadata) do
    log_error("File #{file_metadata.filename} could not be found.")
  end

  defp log_bad_file(:unsupported_file_type, file_metadata) do
    log_error("Unable to process files of type #{Atom.to_string file_metadata.file_type} (#{file_metadata.filename})")
  end

  defp log_bad_file(:unsupported_data_type, file_metadata) do
    log_error("Unable to process #{Atom.to_string file_metadata.data_type} files of type #{Atom.to_string file_metadata.file_type} (#{file_metadata.filename})")
  end

  defp log_bad_file(:ambiguous_data_type, file_metadata) do
    log_error("File may contain multiple types of data (#{file_metadata.filename})")
  end

  defp log_bad_file(:no_data_type, file_metadata) do
    log_error("Unable to determine the type of data in file (#{file_metadata.filename})")
  end
end
