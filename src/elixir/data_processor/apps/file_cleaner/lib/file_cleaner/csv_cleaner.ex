defmodule FileCleaner.CSVCleaner do
  NimbleCSV.define(CSVParser, separator: ",", escape: "\"")

  alias FileCleaner.DateUtils
  alias FileCleaner.OrganisationUtils


  defmodule RowState do
    defstruct previous_minister: :nil
  end


  defmodule MeetingRow do
    defstruct minister: :nil, start_date: :nil, end_date: :nil, organisations: :nil, reason: "", row: 0
  end


  def clean_file(file_metadata=%{data_type: :meetings}) do
    file_metadata.filename
    |> File.stream!
    |> Stream.flat_map(&(String.split &1, "\r"))
    |> CSVParser.parse_stream(headers: :false)
    |> Stream.with_index
    |> Stream.transform(:header, &(clean_meeting_row &1, &2, file_metadata))
    |> Stream.reject(&(&1 == :nil))
    |> Enum.map(&(&1 |> inspect |> IO.puts))

    IO.puts inspect(file_metadata)
    {:ok, file_metadata}
  end

  def clean_file(file_metadata) do
    {:error, :unsupported_data_type, file_metadata}
  end


  defp clean_meeting_row(row, :header, _file_metadata) do
    IO.puts inspect(row)
    # Can make a call here to validate the headers are sensible
    {[:nil], %RowState{}}
  end

  defp clean_meeting_row({[""], _}, row_state, _) do
    {[:nil], row_state}
  end

  defp clean_meeting_row({csv_row, row_index}, row_state, file_metadata) do
    case fetch_meeting_values_from_row(csv_row, row_state) do
    %{minister: minister, date: date, organisations: organisations, reason: reason} ->
      row = %MeetingRow{row: row_index}
            |> parse_and_insert_minister(String.trim(minister), row_state)
            |> parse_and_insert_date(date, file_metadata.year)
            |> parse_and_insert_reason(reason)
            |> parse_and_insert_organisations(organisations)
      {[row], Map.put(row_state, :previous_minister, row.minister)}
    {:error, error} ->
      {[{:error, error, row_index}], row_state}
    end
  end


  defp fetch_meeting_values_from_row([minister, date, organisations, reason], row_state) do
    %{minister: minister, date: date, organisations: organisations, reason: reason}
  end

  defp fetch_meeting_values_from_row(_, _) do
    {:error, :unrecognised_row_format}
  end


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
