defmodule FileCleaner.CSVCleaner do
  NimbleCSV.define(CSVParser, separator: ",", escape: "\"")

  alias FileCleaner.DateUtils
  alias FileCleaner.OrganisationUtils


  @header_types %{
    "organisation" => :organisations,
    "minister" => :minister,
    "date" => :date,
    "reason" => :reason,
    "purpose" => :reason
  }


  defmodule RowState do
    defstruct previous_minister: :nil, data_positions: :nil
  end


  defmodule MeetingRow do
    defstruct minister: :nil, start_date: :nil, end_date: :nil, organisations: :nil, reason: "", row: 0
  end


  def clean_file(file_metadata=%{data_type: :meetings}) do
    processed_rows = file_metadata.filename
                     |> File.stream!
                     |> Stream.flat_map(&(String.split &1, "\r"))
                     |> CSVParser.parse_stream(headers: :false)
                     |> Stream.with_index
                     |> Stream.transform(:header, &(clean_meeting_row &1, &2, file_metadata))
                     |> Stream.reject(&invalid_meetings_row?/1)

    new_metadata = Map.put(file_metadata, :rows, processed_rows)
    {:ok, new_metadata}
  end

  def clean_file(file_metadata) do
    {:error, :unsupported_data_type, file_metadata}
  end


  defp invalid_meetings_row?(:nil), do: true
  defp invalid_meetings_row?(%{start_date: %{month: month, year: year}}) when is_nil(month) or is_nil(year), do: true
  defp invalid_meetings_row?(%{organisations: [""]}), do: true
  defp invalid_meetings_row?(%{minister: :nil}), do: true
  defp invalid_meetings_row?(_), do: false


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
    Map.put(row, :minister, minister)
  end

  defp parse_and_insert_minister(row, minister, _) do
    Map.put(row, :minister, minister)
  end


  defp parse_and_insert_reason(row, reason) do
    Map.put(row, :reason, reason)
  end


  defp parse_and_insert_date(row, date_string, default_year) do
    date_tuple = DateUtils.date_string_to_tuple date_string, default_year
    row
    |> Map.put(:start_date, date_tuple)
    |> Map.put(:end_date, date_tuple)
  end


  defp parse_and_insert_organisations(row, organisations_string) do
    Map.put(row, :organisations, OrganisationUtils.parse_organisations(organisations_string))
  end
end
