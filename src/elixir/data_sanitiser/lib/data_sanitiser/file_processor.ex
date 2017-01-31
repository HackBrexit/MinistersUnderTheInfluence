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
    defstruct previous_minister: :nil, data_positions: :nil
  end


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


  defp clean_meeting_row(row, :header, _file_metadata) do
    data_positions = meeting_data_positions_from_header row
    {[:nil], %RowState{data_positions: data_positions}}
  end

  defp clean_meeting_row({csv_row, row_index}, row_state, file_metadata) do
    case fetch_meeting_values_from_row(csv_row, row_state) do
      %{minister: "", date: "", organisations: "", reason: ""} ->
        {[:nil], row_state}
      %{minister: minister, date: date, organisations: organisations, reason: reason} ->
        row = %MeetingRow{row: row_index}
              |> parse_and_insert_minister(String.trim(minister), row_state)
              |> parse_and_insert_date(date, file_metadata.year)
              |> parse_and_insert_reason(reason)
              |> parse_and_insert_organisations(organisations)
        {[row], Map.put(row_state, :previous_minister, row.minister)}
      _ ->
        if row_is_empty? csv_row do
          {[:nil], row_state}
        else
          {[{:error, :invalid_row, row_index}], row_state}
        end
    end
  end


  defp meeting_data_positions_from_header({header_row, _}) do
    Enum.map header_row, &(extract_column_type String.trim(&1))
  end


  defp extract_column_type(""), do: :empty

  defp extract_column_type(header_value) do
    extract_column_type(header_value, Map.keys(@header_types))
  end

  defp extract_column_type(_header_value, []), do: :unknown

  defp extract_column_type(header_value, [type_key | remaining_types]) do
    key_matches = header_value
                  |> String.downcase
                  |> String.contains?(type_key)
    if key_matches do
      @header_types[type_key]
    else
      extract_column_type(header_value, remaining_types)
    end
  end


  defp fetch_meeting_values_from_row(csv_row, row_state) do
    row_state.data_positions
    |> Enum.zip(csv_row)
    |> Enum.into(%{})
  end


  defp row_is_empty?(csv_row), do: Enum.all? csv_row, &(""  == String.trim &1)


  defp parse_and_insert_minister(row, "", %RowState{previous_minister: minister}) do
    minister
    |> clean_minister_name
    |> put_into_map_at(row, :minister)
  end

  defp parse_and_insert_minister(row, minister, _) do
    minister
    |> clean_minister_name
    |> put_into_map_at(row, :minister)
  end


  defp clean_minister_name(:nil), do: :nil
  defp clean_minister_name(minister) do
    minister
    |> String.replace(~r{^.* Rt Hon}, "Rt Hon")
    |> String.replace(~r{ MP[ ,].*$}, " MP")
    |> String.replace(~r{\(.*\)}, "")
    |> trim_spaces_and_commas
    |> Canonicaliser.canonicalise
  end


  defp parse_and_insert_reason(row, reason) do
    reason
    |> clean_reason
    |> put_into_map_at(row, :reason)
  end


  defp clean_reason(reason) do
    reason
    |> trim_spaces_and_commas
    |> Canonicaliser.canonicalise
  end


  defp parse_and_insert_date(row, date_string, default_year) do
    date_tuple = DateUtils.date_string_to_tuple date_string, default_year
    row
    |> Map.put(:start_date, date_tuple)
    |> Map.put(:end_date, date_tuple)
  end


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
