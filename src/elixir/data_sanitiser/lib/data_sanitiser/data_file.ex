defmodule DataSanitiser.DataFile do
  alias DataSanitiser.DateUtils.DateTuple

  defmodule MeetingRow do
    defstruct minister: :nil, start_date: %DateTuple{}, end_date: %DateTuple{}, organisations: :nil, reason: "", row: 0
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
    def is_valid?(%MeetingRow{start_date: start_date}), do: DateTuple.is_valid? start_date
    def is_valid?(_), do: false
  end
end
