defmodule DataSanitiser.CSVUtils do
  @moduledoc """
  Utility functions for dealing with CSV files.
  """

  NimbleCSV.define(
    DataSanitiser.CSVCleaner.CSVParser, separator: ",", escape: "\""
  )

  alias DataSanitiser.CSVCleaner.CSVParser

  @doc """
    Opens a file and streams as a CSV

    Files are assumed to be in latin1.

    Options will be passed through to the CSV parser. For more info see
    `DataSanitiser.CSVCleaner.CSVParser.parse_stream/2`.

    Most commonly, options are useful for including a header row or not
    by passing `headers: true` or `headers: false`.
  """
  @spec stream_from_csv_file!(String.t, [term]) :: Enumerable.t
  def stream_from_csv_file!(filename, opts \\ []) do
    filename
    |> File.stream!
    |> Stream.map(&(:unicode.characters_to_binary(&1, :latin1)))
    |> Stream.flat_map(&(String.split &1, "\r"))
    |> CSVParser.parse_stream(opts)
  end
end
