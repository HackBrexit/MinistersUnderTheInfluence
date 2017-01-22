defmodule DataProcessor do
  NimbleCSV.define(MetadataCSVParser, separator: ",", escape: "\"")

  def process_metadata_file(metadata_file_path, datafiles_path) do
    metadata_file_path
    |> File.stream!
    |> MetadataCSVParser.parse_stream
    |> Enum.take(1)
    |> Enum.map(&(process_metadata_row(&1, datafiles_path)))
  end

  def process_metadata_row(file_metadata_row, datafiles_path) do
    IO.puts file_metadata_row
    file_metadata_row
    |> convert_row_to_struct
    |> extract_filename(datafiles_path)
    |> extract_file_type
    |> extract_year
    |> extract_data_type
    |> inspect |> IO.puts
    # |> FileProcessor.process
  end

  def convert_row_to_struct([_, name, department, title, publish_date, source_url]) do
    %FileProcessor.FileMetadata{
      name: name,
      department: department,
      title: title,
      date_published: publish_date,
      source_url: source_url
    }
  end

  def extract_filename(file_metadata, _datafiles_path) do
    file_metadata
  end

  def extract_file_type(file_metadata) do
    file_metadata
  end

  def extract_year(file_metadata) do
    file_metadata
  end

  def extract_data_type(file_metadata) do
    file_metadata
  end
end
