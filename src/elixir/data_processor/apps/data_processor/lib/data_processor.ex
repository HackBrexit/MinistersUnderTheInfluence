defmodule DataProcessor do
  NimbleCSV.define(MetadataCSVParser, separator: ",", escape: "\"")

  @known_data_types ["gifts", "hospitality", "meetings", "travel"]
  @year_regular_expressions [
    # Match four digit runs at the start that begin with 19 or 20
    ~R/\A((?:19|20)\d{2})(?:\Z|\D)/,
    # Match four digit runs not at the start (must have a non-digit in front)
    # that begin with 19 or 20
    ~R/(?:\D)((?:19|20)\d{2})(?:\Z|\D)/,
    # Match two digit runs at the start
    ~R/\A(\d{2})(?:\Z|\D)/,
    # Match two digit runs not at the start (must have a non-digit in front)
    ~R/(?:\D)(\d{2})(?:\Z|\D)/
  ]

  def process_metadata_file(metadata_file_path, datafiles_path) do
    metadata_file_path
    |> File.stream!
    |> MetadataCSVParser.parse_stream(headers: false)
    |> Stream.map(&(process_metadata_row(&1, datafiles_path)))
    |> Enum.take(1) # TODO: Remove this line so we can process everything
    |> Enum.map(&FileProcessor.process/1)
  end

  def process_metadata_row(file_metadata_row, datafiles_path) do
    IO.puts file_metadata_row
    file_metadata_row
    |> convert_row_to_struct
    |> extract_filename(datafiles_path)
    |> extract_file_type
    |> extract_year
    |> extract_data_type
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

  def extract_filename(file_metadata, datafiles_path) do
    file_metadata.source_url
    |> String.split("/")
    |> Enum.take(-2)
    |> Enum.join("_")
    |> append_to_path(datafiles_path)
    |> put_into_map_at(file_metadata, :filename)
  end

  defp append_to_path(sub_path, base_path), do: Path.join base_path, sub_path

  defp put_into_map_at(value, map, key), do: Map.put map, key, value

  def extract_file_type(file_metadata) do
    file_metadata.filename
    |> String.split(".")
    |> List.last
    |> String.downcase
    |> String.to_atom
    |> put_into_map_at(file_metadata, :file_type)
  end

  def extract_year(info_string) when is_binary(info_string) do
    years = @year_regular_expressions
            |> Stream.flat_map(&(scan_and_flatten &1, info_string))
            |> Stream.map(&String.to_integer/1)
            |> Enum.map(&normalise_year/1)
    case years do
    [ year ] ->
      year
    [] ->
      :nil
    _ -> :ambiguous
    end
  end

  def extract_year(file_metadata) when is_map(file_metadata) do
    extracted_year = file_metadata
                     |> info_sources
                     |> Enum.map(&extract_year/1)
                     |> reduce_to_single_value
    case extracted_year do
    year when is_integer(year) ->
      year
    _ ->
      :nil
    end
    |> put_into_map_at(file_metadata, :year)
  end

  defp scan_and_flatten(regex, string) do
    regex
    |> Regex.scan(string, capture: :all_but_first)
    |> List.flatten
  end

  defp normalise_year(year) when year < 100, do: normalise_year(year + 2000)
  defp normalise_year(year) do
    current_year = DateTime.utc_now.year
    cond do
      year > current_year -> year - 100
      true -> year
    end
  end

  def extract_data_type(info_string) when is_binary(info_string) do
    lower_info_string = String.downcase info_string
    case Enum.filter @known_data_types, &(String.contains? lower_info_string, &1) do
      [ type ] ->
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

  defp info_sources(%{filename: filename, name: name, title: title}) do
    [ (filename |> Path.basename),
      name,
      title
    ]
  end

  defp reduce_to_single_value([head | tail]), do: reduce_to_single_value tail, head
  defp reduce_to_single_value([], type), do: type
  defp reduce_to_single_value([head | tail], head), do: reduce_to_single_value tail, head
  defp reduce_to_single_value([head | tail], :nil), do: reduce_to_single_value tail, head
  defp reduce_to_single_value([:nil | tail], type), do: reduce_to_single_value tail, type
  defp reduce_to_single_value([:ambiguous | _tail], _type), do: :ambiguous
  defp reduce_to_single_value([_head | _tail], _type), do: :ambiguous

end
