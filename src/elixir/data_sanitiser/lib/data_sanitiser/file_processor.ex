defmodule DataSanitiser.FileProcessor do
  use Application

  alias DataSanitiser.FileMetadata


  @processing_steps [
    :check_file_exists,
    :check_has_single_data_type,
    :clean_file
  ]


  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: FileProcessor.Worker.start_link(arg1, arg2, arg3)
      # worker(FileProcessor.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FileProcessor.Supervisor]
    Supervisor.start_link(children, opts)
  end


  def process(file_metadata) do
    case do_process @processing_steps, file_metadata do
    {:ok, file_metadata} ->
      {:ok, file_metadata}
    {:error, error, file_metadata} ->
      log_bad_file(error, file_metadata)
      {:error, error, file_metadata}
    end
  end


  defp do_process([], file_metadata), do: {:ok, file_metadata}

  defp do_process([:check_file_exists | remaining_steps], file_metadata) do
    if File.exists? file_metadata.filename do
      do_process remaining_steps, file_metadata
    else
      {:error, :not_found, file_metadata}
    end
  end

  defp do_process([:clean_file | remaining_steps], file_metadata) do
    case do_clean_file file_metadata do
    :ok ->
      do_process remaining_steps, file_metadata
    error ->
      error
    end
  end

  defp do_process([:check_has_single_data_type | remaining_steps], file_metadata) do
    case file_metadata.data_type do
    :ambiguous ->
      {:error, :ambiguous_data_type, file_metadata}
    :nil ->
      {:error, :no_data_type, file_metadata}
    _ ->
      do_process remaining_steps, file_metadata
    end
  end


  def do_clean_file(file_metadata = %FileMetadata{file_type: :csv}) do
    DataSanitiser.FileCleaner.CSVCleaner.clean_file file_metadata
  end

  def do_clean_file(file_metadata) do
    log_bad_file :unsupported_file_type, file_metadata
  end


  def log_bad_file(:not_found, file_metadata) do
    log_error "File #{file_metadata.filename} could not be found." 
  end

  def log_bad_file(:unsupported_file_type, file_metadata) do
    log_error "Unable to process files of type #{Atom.to_string file_metadata.file_type} (#{file_metadata.filename})"
  end

  def log_bad_file(:unsupported_data_type, file_metadata) do
    log_error "Unable to process #{Atom.to_string file_metadata.data_type} files of type #{Atom.to_string file_metadata.file_type} (#{file_metadata.filename})"
  end

  def log_bad_file(:ambiguous_data_type, file_metadata) do
    log_error "File may contain multiple types of data (#{file_metadata.filename})"
  end

  def log_bad_file(:no_data_type, file_metadata) do
    log_error "Unable to determine the type of data in file (#{file_metadata.filename})"
  end


  defp log_error(message) do
    IO.puts message
  end
end
