defmodule DataSanitiser.MetadataProcessor do
  NimbleCSV.define(DefaultCSVParser, separator: ",", escape: "\"")

  alias DataSanitiser.FileProcessor
  alias DataSanitiser.TransparencyData.DataFile
  alias DataSanitiser.TransparencyData.MeetingRow
  alias DataSanitiser.DateUtils

  import DataSanitiser.GeneralUtils, only: [put_into_map_at: 3]

  @known_data_types ["gifts", "hospitality", "meetings", "travel"]


  def run(metadata_file_path, datafiles_path) do
    write_header_row
    metadata_file_path
    |> File.stream!
    |> DefaultCSVParser.parse_stream(headers: false)
    |> Stream.map(&(process_metadata_row(&1, datafiles_path)))
    |> Stream.map(&FileProcessor.process/1)
    |> DataFile.stream_clean_data_to_csv
    |> DefaultCSVParser.dump_to_stream
    |> Enum.into(File.stream!("processed_data.csv", [:delayed_write, :append]))
  end


  def write_header_row() do
    [MeetingRow.header_row]
    |> DefaultCSVParser.dump_to_stream
    |> Enum.into(File.stream!("processed_data.csv", [:delayed_write]))
  end


  def process_metadata_row(file_metadata_row, datafiles_path) do
    file_metadata_row
    |> convert_row_to_struct
    |> extract_filename(datafiles_path)
    |> extract_file_type
    |> extract_year
    |> extract_data_type
  end


  def convert_row_to_struct([_, name, department, title, publish_date, source_url]) do
    %DataFile{
      name: name,
      department: department,
      title: title,
      date_published: publish_date,
      source_url: source_url
    }
  end


  def extract_filename(file_metadata, datafiles_path) do
    file_metadata.source_url
    |> String.split("/")
    |> Enum.take(-2)
    |> Enum.join("_")
    |> append_to_path(datafiles_path)
    |> put_into_map_at(file_metadata, :filename)
  end


  defp append_to_path(sub_path, base_path), do: Path.join base_path, sub_path


  def extract_file_type(file_metadata) do
    file_metadata.filename
    |> String.split(".")
    |> List.last
    |> String.downcase
    |> String.to_atom
    |> put_into_map_at(file_metadata, :file_type)
  end


  def extract_year(file_metadata) do
    extracted_year = file_metadata
                     |> info_sources
                     |> Enum.map(&DateUtils.extract_year_from_string/1)
                     |> reduce_to_single_value
    case extracted_year do
      year when is_integer(year) ->
        year
      _ ->
        :nil
    end
    |> put_into_map_at(file_metadata, :year)
  end


  def extract_data_type(info_string) when is_binary(info_string) do
    lower_info_string = String.downcase info_string
    case Enum.filter @known_data_types, &(String.contains? lower_info_string, &1) do
      [type] ->
        String.to_atom type
      [] ->
        :nil
      _ ->
        :ambiguous
    end
  end

  def extract_data_type(file_metadata) when is_map(file_metadata) do
    file_metadata
    |> info_sources
    |> Enum.map(&extract_data_type/1)
    |> reduce_to_single_value
    |> put_into_map_at(file_metadata, :data_type)
  end


  defp info_sources(%{filename: filename}) do
    [(filename |> Path.basename)]
  end


  defp reduce_to_single_value([head | tail]), do: reduce_to_single_value tail, head
  defp reduce_to_single_value([], type), do: type
  defp reduce_to_single_value([head | tail], head), do: reduce_to_single_value tail, head
  defp reduce_to_single_value([head | tail], :nil), do: reduce_to_single_value tail, head
  defp reduce_to_single_value([:nil | tail], type), do: reduce_to_single_value tail, type
  defp reduce_to_single_value([:ambiguous | _tail], _type), do: :ambiguous
  defp reduce_to_single_value([_head | _tail], _type), do: :ambiguous

end
