defmodule DataSanitiser.FileProcessor.CSV do
  @moduledoc """
  Functions to assist with the processing of transparency files saved as CSVs.
  """

  alias DataSanitiser.CSVUtils
  alias DataSanitiser.TransparencyData.DataFile

  @doc """
  Reads a file and returns a stream of its data.

  Only reads meetings files at the moment.
  Streams the data out one row at a time, including the first (header) row.
  Each entry will be a tuple of `{data_row, row_index}`.
  """
  @spec extract_data!(DataFile.t) :: Enumerable.t
  def extract_data!(%DataFile{file_type: :csv, filename: filename}) do
    filename
    |> CSVUtils.stream_from_csv_file!(headers: false)
    |> Stream.with_index
  end
end
