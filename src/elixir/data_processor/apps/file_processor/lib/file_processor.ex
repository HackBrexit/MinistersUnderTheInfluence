defmodule FileProcessor do
  use Application

  @processing_steps [
    :check_file_exists,
    :check_data_type,
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

  def log_bad_file(:not_found, file_metadata) do
    log_error("File #{file_metadata.filename} could not be found.")
  end

  defp log_error(message) do
    IO.puts message
  end
end
