defmodule FileProcessor do
  use Application

  @file_checks [
    {&FileProcessor.file_exists?/1, :not_found}
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
    file_metadata
    |> do_file_checks
    |> do_process
  end

  defp do_file_checks(file_metadata), do: do_file_checks(@file_checks, file_metadata)
  defp do_file_checks([], file_metadata), do: {:ok, file_metadata}
  defp do_file_checks([{check?, error} | remaining_checks], file_metadata) do
    if check?.(file_metadata) do
      do_file_checks(remaining_checks, file_metadata)
    else
      {:error, error, file_metadata}
    end
  end

  defp do_process({:error, error, file_metadata}) do
    log_bad_file(error, file_metadata)
    {:error, file_metadata}
  end

  defp do_process({:ok, file_metadata}) do
    file_metadata
    |> inspect
    |> IO.puts
    {:ok, file_metadata}
  end

  def file_exists?(file_metadata) do
    File.exists? file_metadata.filename
  end

  def log_bad_file(:not_found, file_metadata) do
    log_error("File #{file_metadata.filename} could not be found.")
  end

  defp log_error(message) do
    IO.puts message
  end
end
