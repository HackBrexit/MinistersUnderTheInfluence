defmodule FileCleaner.CSVCleaner do
  NimbleCSV.define(CSVParser, separator: ",", escape: "\"")

  def clean_file(file_metadata=%{data_type: :meetings}) do
    IO.puts inspect(file_metadata)
    {:ok, file_metadata}
  end

  def clean_file(file_metadata) do
    {:error, :unsupported_data_type, file_metadata}
  end
end
