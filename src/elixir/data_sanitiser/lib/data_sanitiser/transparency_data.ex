defmodule DataSanitiser.TransparencyData do
  alias DataSanitiser.DateUtils.DateTuple


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

    @spec is_valid?(any) :: boolean
    def is_valid?(%MeetingRow{organisations: [""]}), do: false
    def is_valid?(%MeetingRow{minister: :nil}), do: false
    def is_valid?(%MeetingRow{start_date: start_date}) do
      DateTuple.is_valid? start_date
    end
    def is_valid?(_), do: false
  end
end
