defmodule DataSanitiser.FileProcessor.CSV do
  @moduledoc """
  Functions to assist with the processing of transparency files saved as CSVs.
  """

  alias DataSanitiser.CSVUtils

  @doc """
  Reads a file and returns a stream of its data.

  Only reads meetings files at the moment.
  Streams the data out one row at a time, including the first (header) row.
  """
  @spec extract_data!(DataFile.t) :: Enumerable.t
  def extract_data!(%{data_type: :meetings, filename: filename}) do
    CSVUtils.stream_from_csv_file!(filename, headers: false)
  end
end
