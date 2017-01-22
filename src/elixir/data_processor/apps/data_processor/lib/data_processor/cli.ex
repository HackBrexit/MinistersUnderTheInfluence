defmodule DataProcessor.CLI do
  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help

  Otherwise it is the path to the metadata csv file and the path to the
  directory holding all the data files.

  Return a tuple of `{ metadata_file_path, datafiles_path }` or `:help` if help
  was given
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases: [h: :help])
    case parse do
      { [ help: true ], _, _ }
        -> :help
      { _, [ metadata_file_path, datafiles_path ], _ }
        -> { metadata_file_path, datafiles_path }
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: data_processor <path_to_metadata_list> <path to datafiles directory>
    """
    System.halt(0)
  end

  def process({ metadata_file_path, datafiles_path }) do
    DataProcessor.process_metadata_file(metadata_file_path, datafiles_path)
  end
end
