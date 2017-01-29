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

  @doc """
  Opens a file as a CSV and streams an enumerable into it.

  Each entry of the enumerable needs to be an enumerable itself and represents
  a row of the csv.
  """
  @spec stream_to_csv_file!(Enumerable.t, String.t, [any] | :nil, [term]) :: :ok
  def stream_to_csv_file!(source_stream, filename, header_row, options \\ [])
  def stream_to_csv_file!(source_stream, filename, :nil, options) do
    do_stream_to_csv_file!(source_stream, filename, options)
  end

  def stream_to_csv_file!(source_stream, filename, header_row, options) do
    [header_row]
    |> Stream.concat(source_stream)
    |> do_stream_to_csv_file!(filename, options)
  end

  defp do_stream_to_csv_file!(source_stream, filename, options) do
    output_stream = File.stream!(filename, options)

    source_stream
    |> CSVParser.dump_to_stream
    |> Enum.into(output_stream)

    :ok
  end
end
