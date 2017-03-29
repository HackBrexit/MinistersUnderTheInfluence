defmodule DataSanitiser.TransparencyData do
  @moduledoc """
  Various structures representing transparency data files/parts of files
  """

  alias DataSanitiser.DateUtils.DateTuple


  defprotocol DataFileRow do
    @moduledoc """
    Define some common functions shared by all row types.

    These are `is_valid?/1` to say if the data in the row is good or not and
    `prepare_for_csv/3` which ensures the row is nicely formatted and ready to
    to output to a 'cleaned' csv file.
    """

    @fallback_to_any true

    @spec is_valid?(any) :: boolean
    def is_valid?(row)

    @spec prepare_for_csv(
            any, DataSanitiser.TransparencyData.DataFile.t, pos_integer
          ) :: Enumerable.t
    def prepare_for_csv(row, data_file, row_index)
  end

  defimpl DataFileRow, for: Any do
    def is_valid?(_), do: false
    def prepare_for_csv(_, _, _), do: []
  end


  defmodule DataFile do
    @moduledoc """
    Structure representing a single transparency data file.

    Holds enough information to allow the file to be read and cleaned, and then
    can also hold the cleaned data too.
    """

    defstruct name: "",
              department: "",
              title: "",
              date_published: "",
              source_url: "",
              file_type: :nil,
              filename: "",
              year: :nil,
              data_type: :nil,
              rows: []

    @type file_type :: atom

    @type data_type :: :gifts
                     | :hospitality
                     | :meetings
                     | :travel
                     | :ambiguous
                     | :nil

    @type row_type :: DataSanitiser.TransparencyData.MeetingRow.t

    @type t :: %DataFile{
                 name: String.t,
                 department: String.t,
                 title: String.t,
                 date_published: String.t,
                 source_url: String.t,
                 file_type: file_type,
                 filename: String.t,
                 year: pos_integer | :nil,
                 data_type: data_type,
                 rows: [row_type]
              }

    @spec is_valid?(any) :: boolean
    def is_valid?(%DataFile{}), do: true
    def is_valid?(_), do: false

    @doc """
    Stream several cleaned data files one row at a time formatted for CSV.

    Excludes a header line but includes all valid data from the files passed
    in, in one continuous stream. Each 'row' will be a list of values that
    can be converted to a string cleanly.
    """
    @spec stream_cleaned_data(Enumerable.t) :: Enumerable.t
    def stream_cleaned_data(processed_files) do
      processed_files
      |> Stream.filter(fn ({:ok,_}) -> true; (_) -> false end)
      |> Stream.transform(1, &stream_clean_rows_to_csv/2)
    end

    @doc """
    Stream any valid rows out in a CSV ready format.
    """
    @spec stream_clean_rows_to_csv(
            {:ok, DataFile.t}, non_neg_integer
          ) :: Enumerable.t
    def stream_clean_rows_to_csv({:ok, data_file}, next_row_id) do
      valid_rows = data_file.rows
                   |> Enum.filter(&DataFileRow.is_valid?/1)
      row_stream = valid_rows
                   |> Stream.transform(
                        next_row_id,
                        fn row, row_id ->
                          {
                            DataFileRow.prepare_for_csv(row, data_file, row_id),
                            row_id + 1
                          }
                        end 
                      )
      {row_stream, next_row_id + length(valid_rows)}
    end

    @doc """
    Read in the data from the file on disk and stream one entry at a time.
    """
    @spec extract_data(DataFile.t) :: {:ok, Enumerable.t}
                                    | {:error, atom, DataFile.t}
    def extract_data(file_metadata = %DataFile{file_type: :csv}) do
      {:ok, DataSanitiser.FileProcessor.CSV.extract_data!(file_metadata)}
    end

    def extract_data(file_metadata) do
      {:error, :unsupported_file_type, file_metadata}
    end
  end


  defmodule MeetingRow do
    @moduledoc """
    Structure for storing the data that can be extracted from a meeting entry.
    """

    defstruct minister: :nil,
              start_date: %DateTuple{},
              end_date: %DateTuple{},
              organisations: :nil,
              reason: "",
              row: 0
    @type t :: %MeetingRow{
      minister: String.t | :nil,
      start_date: DateTuple.t,
      end_date: DateTuple.t,
      organisations: [String.t] | :nil,
      reason: String.t,
      row: non_neg_integer
    }

    @doc """
    Convert the data in the row into a 'cleaned CSV' format.
    """
    @spec prepare_for_csv(
            MeetingRow.t, DataFile.t, non_neg_integer
          ) :: Enumerable.t
    def prepare_for_csv(row = %MeetingRow{}, data_file, row_index) do
      row.organisations
      |> Stream.map(&(prepare_for_csv(&1, row, data_file, row_index)))
    end

    def prepare_for_csv(organisation, row, data_file, row_index) do
      [
        row_index,
        row.minister,
        "",
        data_file.department,
        row.start_date,
        row.end_date,
        organisation,
        "",
        row.reason,
        0,
        Path.basename(data_file.filename),
        row.row
      ]
    end


    @spec is_valid?(any) :: boolean
    def is_valid?(%MeetingRow{organisations: [""]}), do: false
    def is_valid?(%MeetingRow{minister: :nil}), do: false
    def is_valid?(%MeetingRow{start_date: start_date}) do
      DateTuple.is_valid? start_date
    end
    def is_valid?(_), do: false

    @doc """
    The headings to associate with the output of `prepare_for_csv`.
    """
    @spec header_row :: [String.t]
    def header_row do
      [
        "Meeting ID",
        "Minister",
        "Role",
        "Department",
        "Start Date",
        "End Date",
        "Organisation",
        "Representative",
        "Reason",
        "Hospitality?",
        "Original File",
        "Original Row"
      ]
    end
  end

  defimpl DataFileRow, for: MeetingRow do
    def is_valid?(row), do: MeetingRow.is_valid?(row)
    def prepare_for_csv(row, data_file, row_index) do
      MeetingRow.prepare_for_csv(row, data_file, row_index)
    end
  end
end
