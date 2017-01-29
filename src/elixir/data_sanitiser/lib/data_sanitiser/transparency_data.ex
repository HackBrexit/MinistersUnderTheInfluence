defmodule DataSanitiser.TransparencyData do
  alias DataSanitiser.DateUtils.DateTuple


  defprotocol DataFileRow do
    @fallback_to_any true
    def is_valid?(row)
    def prepare_for_csv(row, data_file, row_index)
  end

  defimpl DataFileRow, for: Any do
    def is_valid?(_), do: false
    def prepare_for_csv(_, _, _), do: []
  end


  defmodule DataFile do
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

    @type row_type :: MeetingRow.t

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
    def is_valid?(_), do: true

    def stream_clean_data_to_csv(processed_files) do
      processed_files
      |> Stream.filter(fn ({:ok,_}) -> true; (_) -> false end)
      |> Stream.transform(1, &stream_clean_rows_to_csv/2)
    end

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
  end


  defmodule MeetingRow do
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
      organisations: [String.t],
      reason: String.t,
      row: non_neg_integer
    }

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
