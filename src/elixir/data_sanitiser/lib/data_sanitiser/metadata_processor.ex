defmodule DataSanitiser.MetadataProcessor do
  @moduledoc """
  Handle the processing of the transparency metadata file.

  Everything needed to work through the metadata file, and appropriately
  process (or not) each file it references.
  """

  alias DataSanitiser.FileProcessor
  alias DataSanitiser.TransparencyData.DataFile
  alias DataSanitiser.TransparencyData.MeetingRow
  alias DataSanitiser.DateUtils
  alias DataSanitiser.CSVUtils

  import DataSanitiser.GeneralUtils, only: [
    put_into_map_at: 3,
    reduce_to_single_value: 1,
    append_to_path: 2
  ]

  @known_data_types ["gifts", "hospitality", "meetings", "travel"]


  @doc """
  """
  @spec run(String.t, String.t) :: :ok
  def run(metadata_file_path, datafiles_path) do
    metadata_file_path
    |> CSVUtils.stream_from_csv_file!(headers: false)
    |> Stream.map(&(process_metadata_row(&1, datafiles_path)))
    |> Stream.map(&FileProcessor.process/1)
    |> DataFile.stream_cleaned_data
    |> CSVUtils.stream_to_csv_file!(
         "processed_data.csv",
         MeetingRow.header_row,
         [:delayed_write]
       )

    :ok
  end


  @doc """
  Extract as much information as possible from a row of a metadata file.

  The resulting output is a `DataSanitiser.TransparencyData.DataFile` with
  the extracted data in it.
  On top of putting the data from the row into the struct, this also extracts
  the full file path, the format of the file, the year the file refers to and
  the type of data the file contains.

  ## Examples
      iex> import DataSanitiser.MetadataProcessor,
      ...>   only: [process_metadata_row: 2]
      iex> metadata_row = [
      ...>   1, "Data from '99", "Department of Technology",
      ...>   "Meetings Data", "2016-01-12T12:34:56+00:00",
      ...>   "http://example.com/12345/Meetings-June-99.csv"
      ...> ]
      iex> process_metadata_row(metadata_row, "/base/path/for/files")
      %DataSanitiser.TransparencyData.DataFile{
        name: "Data from '99", department: "Department of Technology",
        title: "Meetings Data", year: 1999,
        date_published: "2016-01-12T12:34:56+00:00",
        source_url: "http://example.com/12345/Meetings-June-99.csv",
        filename: "/base/path/for/files/12345_Meetings-June-99.csv",
        file_type: :csv, data_type: :meetings, rows: []
      }
  """
  @spec process_metadata_row([String.t], String.t) :: DataFile.t
  def process_metadata_row(file_metadata_row, datafiles_path) do
    file_metadata_row
    |> convert_row_to_struct
    |> extract_filename(datafiles_path)
    |> extract_file_type
    |> extract_year
    |> extract_data_type
  end


  @spec convert_row_to_struct([String.t]) :: DataFile.t
  defp convert_row_to_struct([_, name, dept, title, pub_date, source_url]) do
    %DataFile{
      name: name,
      department: dept,
      title: title,
      date_published: pub_date,
      source_url: source_url
    }
  end


  @spec extract_filename(DataFile.t, String.t) :: DataFile.t
  defp extract_filename(file_metadata, datafiles_path) do
    file_metadata.source_url
    |> String.split("/")
    |> Enum.take(-2)
    |> Enum.join("_")
    |> append_to_path(datafiles_path)
    |> put_into_map_at(file_metadata, :filename)
  end


  @spec extract_file_type(DataFile.t) :: DataFile.t
  defp extract_file_type(file_metadata) do
    file_metadata.filename
    |> String.split(".")
    |> List.last
    |> String.downcase
    |> String.to_atom
    |> put_into_map_at(file_metadata, :file_type)
  end


  @spec extract_year(DataFile.t) :: DataFile.t
  defp extract_year(file_metadata) do
    extracted_year = file_metadata
                     |> info_sources
                     |> Enum.map(&DateUtils.extract_year_from_string/1)
                     |> reduce_to_single_value
    # We don't care about ambiguous years here, so treat them as if none
    # was found.
    case extracted_year do
      year when is_integer(year) ->
        year
      _ ->
        :nil
    end
    |> put_into_map_at(file_metadata, :year)
  end


  @spec extract_data_type(DataFile.t) :: DataFile.t
  defp extract_data_type(file_metadata=%DataFile{}) do
    file_metadata
    |> info_sources
    |> Enum.map(&extract_data_type/1)
    |> reduce_to_single_value
    |> put_into_map_at(file_metadata, :data_type)
  end

  @spec extract_data_type(String.t) :: DataFile.data_type
  defp extract_data_type(info_string) when is_binary(info_string) do
    # Try to determine the type of data the file contains from a string.

    lower_string = String.downcase info_string
    case Enum.filter @known_data_types, &(String.contains? lower_string, &1) do
      [type] ->
        String.to_atom type
      [] ->
        :nil
      _ ->
        :ambiguous
    end
  end

  @spec info_sources(DataFile.t) :: [String.t]
  defp info_sources(%DataFile{filename: filename}) do
    # Extracts a list of strings from a DataFile object which can be used
    # for extracting information such as the year and data type.

    [(filename |> Path.basename)]
  end

end
