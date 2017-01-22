defmodule FileCleaner.CSVCleaner do
  NimbleCSV.define(CSVParser, separator: ",", escape: "\"")

  defmodule RowState do
    defstruct previous_minister: :nil
  end

  defmodule MeetingRow do
    defstruct minister: :nil, start_date: :nil, end_date: :nil, organisations: :nil, reason: "", row: 0
  end

  def clean_file(file_metadata=%{data_type: :meetings}) do
    file_metadata.filename
    |> File.stream!
    |> CSVParser.parse_stream(headers: :false)
    |> Stream.with_index
    |> Stream.transform(:header, &(clean_meeting_row &1, &2, file_metadata))
    |> Stream.reject(&(&1 == :header))
    |> Enum.to_list |> inspect |> IO.puts

    IO.puts inspect(file_metadata)
    {:ok, file_metadata}
  end

  def clean_file(file_metadata) do
    {:error, :unsupported_data_type, file_metadata}
  end

  defp clean_meeting_row(row, :header, file_metadata) do
    IO.puts inspect(row)
    # Can make a call here to validate the headers are sensible
    {[:header], %RowState{}}
  end

  defp clean_meeting_row(row, row_state, file_metadata) do
    new_row = %MeetingRow{}
    {[new_row], Map.put(row_state, :previous_minister, new_row.minister)}
  end
end
