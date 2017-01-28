defmodule DataSanitiser.DateUtils do

  defmodule DateTuple do
    defstruct day: :nil, month: :nil, year: :nil
    @type t :: %DateTuple{day: 1..31 | :nil, month: 1..12 | :nil, year: pos_integer | :nil}

    @spec is_valid?(DateTuple.t) :: boolean
    def is_valid?(%DateTuple{month: month}) when is_nil(month), do: false
    def is_valid?(%DateTuple{year: year}) when is_nil(year), do: false
    def is_valid?(_), do: true
  end

  defimpl String.Chars, for: DateTuple do
    @spec to_string(DateTuple.t) :: String.t
    def to_string(%DateTuple{day: :nil, month: month, year: year}) do
      Enum.join [
        (month |> Integer.to_string |> String.rjust(2, ?0)),
        year
      ], "-"
    end

    def to_string(%DateTuple{day: day, month: month, year: year}) do
      Enum.join [
        (day |> Integer.to_string |> String.rjust(2, ?0)),
        (month |> Integer.to_string |> String.rjust(2, ?0)),
        year
      ], "-"
    end
  end


  @recognised_months %{
    "jan" => 1,
    "january" => 1,
    "feb" => 2,
    "february" => 2,
    "mar" => 3,
    "march" => 3,
    "apr" => 4,
    "april" => 4,
    "may" => 5,
    "jun" => 6,
    "june" => 6,
    "jul" => 7,
    "july" => 7,
    "aug" => 8,
    "august" => 8,
    "sep" => 9,
    "sept" => 9,
    "september" => 9,
    "oct" => 10,
    "october" => 10,
    "nov" => 11,
    "november" => 11,
    "dec" => 12,
    "december" => 12
  }

  @date_regex ~r{^(?:(?<day>\d?\d)?[-/ ])??(?<month>#{Enum.join Map.keys(@recognised_months), "|"}|\d?\d)[-/ ]?(?<year>(19|20)?\d\d)?$}

  @year_regular_expressions [
    # Match four digit runs at the start that begin with 19 or 20
    ~R/\A((?:19|20)\d{2})(?:\Z|\D)/,
    # Match four digit runs not at the start (must have a non-digit in front)
    # that begin with 19 or 20
    ~R/(?:\D)((?:19|20)\d{2})(?:\Z|\D)/,
    # Match two digit runs at the start
    ~R/\A(\d{2})(?:\Z|\D)/,
    # Match two digit runs not at the start (must have a non-digit in front)
    ~R/(?:\D)(\d{2})(?:\Z|\D)/
  ]


  @spec normalise_day(String.t | integer) :: 1..31 | :nil
  def normalise_day(""), do: :nil
  def normalise_day(day) when is_binary(day), do: normalise_day String.to_integer day
  def normalise_day(day) when day > 0 and day < 32, do: day
  def normalise_day(_), do: :nil 


  @spec normalise_month(String.t | integer) :: 1..12 | :nil
  def normalise_month(month) when is_binary(month) do
    case Integer.parse month do
    :error ->
      Map.get @recognised_months, String.downcase(month)
    {month_integer, ""} ->
      normalise_month month_integer
    end
  end
  def normalise_month(month) when month > 0 and month < 13, do: month
  def normalise_month(_), do: :nil


  @spec normalise_year(String.t | integer) :: integer | :nil
  def normalise_year(""), do: :nil
  def normalise_year(year) when is_binary(year), do: normalise_year String.to_integer(year)
  def normalise_year(year) when year < 100, do: normalise_year(year + 2000)
  def normalise_year(year) do
    current_year = DateTime.utc_now.year
    cond do
      year > current_year -> year - 100
      true -> year
    end
  end


  @spec parse_date_string(String.t) :: { 1..31 | :nil, 1..12 | :nil, pos_integer | :nil }
  defp parse_date_string(date_string) do
    case Regex.named_captures @date_regex, String.downcase(date_string) do
    %{ "day" => day, "month" => month, "year" => year }
      -> { normalise_day(day), normalise_month(month), normalise_year(year) }
    _
      -> { :nil, :nil, :nil }
    end
  end


  @spec date_string_to_tuple(String.t, pos_integer | :nil) :: DateTuple.t
  def date_string_to_tuple(date_string, default_year) do
    case parse_date_string date_string do
    { _, :nil, _ }
      -> %DateTuple{ day: :nil, month: :nil, year: :nil }
    { day, month, :nil }
      -> %DateTuple{ day: day, month: month, year: default_year }
    { day, month, year }
      -> %DateTuple{ day: day, month: month, year: year }
    end
  end


  @spec extract_year_from_string(String.t) :: pos_integer | :ambiguous | :nil
  def extract_year_from_string(string) when is_binary(string) do
    years = @year_regular_expressions
            |> Stream.flat_map(&(scan_and_flatten &1, string))
            |> Enum.map(&String.to_integer/1)
    case years do
    [ year ] when year < 100 ->
      normalise_year year
    [ year ] ->
      year
    [] ->
      :nil
    _ ->
      :ambiguous
    end
  end


  @spec scan_and_flatten(Regex.t, String.t) :: [String.t, ...] | []
  defp scan_and_flatten(regex, string) do
    regex
    |> Regex.scan(string, capture: :all_but_first)
    |> List.flatten
  end
end
