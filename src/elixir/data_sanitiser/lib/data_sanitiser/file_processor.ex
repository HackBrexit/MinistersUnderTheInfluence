defmodule DataSanitiser.FileProcessor do
  @moduledoc """
  Handle the processing of a single file.

  This contains all that's needed to handle the generic case of processing a
  file, running checks on things and then finally executing the appropriate
  cleaning function for the specific file and data type.
  """
  alias DataSanitiser.TransparencyData.DataFile

  import DataSanitiser.GeneralUtils, only: [log_error: 1]
  @processing_steps [
    :check_file_exists,
    :check_has_single_data_type,
    :clean_file
  ]


  @doc """
  Read in a file, process its data and return it.

  Reads in the file specified in the `DataSanitiser.TransparencyData.DataFile`
  provided, process its rows and then return the original struct with the rows
  included.

  Processing is done by passing the data through a series of steps, as defined
  in @processing_steps.

  As long as even some data was able to be processed a tuple starting with `:ok`
  will be returned.

  Otherwise, if an error occurs that prevents the file being processed at all
  then a tuple starting with `:error` will be returned.
  """
  @spec process(DataFile.t) :: {:ok, DataFile.t} | {:error, atom, DataFile.t}
  def process(file_metadata) do
    case do_process(@processing_steps, file_metadata) do
      {:ok, file_metadata} ->
        {:ok, file_metadata}
      {:error, error, file_metadata} ->
        log_bad_file(error, file_metadata)
        {:error, error, file_metadata}
    end
  end


  # If we got to the end then we didn't hit a problem so return :ok
  @spec do_process([atom], DataFile.t) :: {:ok, DataFile.t}
                                        | {:error, atom, DataFile.t}
  defp do_process([], file_metadata), do: {:ok, file_metadata}

  defp do_process([:check_file_exists | remaining_steps], file_metadata) do
    if File.exists?(file_metadata.filename) do
      do_process(remaining_steps, file_metadata)
    else
      {:error, :not_found, file_metadata}
    end
  end

  defp do_process([:clean_file | remaining_steps], file_metadata) do
    case do_clean_file(file_metadata) do
      :ok ->
        do_process(remaining_steps, file_metadata)
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
        do_process(remaining_steps, file_metadata)
    end
  end


  @spec do_clean_file(DataFile.t) :: {:ok, DataFile.t}
                                   | {:error, atom, DataFile.t} 
  defp do_clean_file(file_metadata = %DataFile{file_type: :csv}) do
    DataSanitiser.CSVCleaner.clean_file(file_metadata)
  end

  defp do_clean_file(file_metadata) do
    log_bad_file(:unsupported_file_type, file_metadata)
  end


  @spec log_bad_file(atom, DataFile.t) :: :ok
  defp log_bad_file(:not_found, file_metadata) do
    log_error("File #{file_metadata.filename} could not be found.")
  end

  defp log_bad_file(:unsupported_file_type, file_metadata) do
    log_error("Unable to process files of type #{Atom.to_string file_metadata.file_type} (#{file_metadata.filename})")
  end

  defp log_bad_file(:unsupported_data_type, file_metadata) do
    log_error("Unable to process #{Atom.to_string file_metadata.data_type} files of type #{Atom.to_string file_metadata.file_type} (#{file_metadata.filename})")
  end

  defp log_bad_file(:ambiguous_data_type, file_metadata) do
    log_error("File may contain multiple types of data (#{file_metadata.filename})")
  end

  defp log_bad_file(:no_data_type, file_metadata) do
    log_error("Unable to determine the type of data in file (#{file_metadata.filename})")
  end
end
