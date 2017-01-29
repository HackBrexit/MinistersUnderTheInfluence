defmodule DataSanitiser.DateUtils do
  @moduledoc """
  Functions and structures for dealing with dates from transparency data files.

  Dates in the files come in many forms and at the end of it all we need to
  ensure that we have extracted at least a month and a year. Sometimes the year
  will only be mentioned in the filename or in some metadata around the file so
  it may have to be linked through that way.
 
  Occasionally dates will be represented as a range. These are currently
  unsupported.
  """

  defmodule DateTuple do
    @moduledoc """
    Struct to represent a date by it's day, month and year components.

    Also provides a helper function in
    `DataSanitiser.DateUtils.DateTuple.is_valid?/1` which will check that the
    date represented by the tuple is valid. See implementation for more
    details.
    """

    defstruct [:day, :month, :year]
    @type t :: %DateTuple{
      day: 1..31 | :nil,
      month: 1..12 | :nil,
      year: pos_integer | :nil
    }

    @doc """
    Checks if a given `DataSanitiser.DateUtils.DateTuple` is valid.
    
    For a `DataSanitiser.DateUtils.DateTuple` to pass it must have at least
    a month and a year which when put together with the day form a valid date
    (when checking dates with a day value of `:nil` it will check the first of
     the month).
    All other types are assumed invalid and return `false`.

    ## Examples
        iex> dt = %DataSanitiser.DateUtils.DateTuple{
        ...>        day: 1, month: 1, year: 2002
        ...>      }
        iex> DataSanitiser.DateUtils.DateTuple.is_valid?(dt)
        true

        iex> dt = %DataSanitiser.DateUtils.DateTuple{day: 1, year: 2002}
        iex> DataSanitiser.DateUtils.DateTuple.is_valid?(dt)
        false
    """
    @spec is_valid?(DateTuple.t) :: boolean
    def is_valid?(date_tuple)

    def is_valid?(%DateTuple{month: month}) when is_nil(month),
      do: false

    def is_valid?(%DateTuple{year: year}) when is_nil(year),
      do: false

    def is_valid?(date_tuple=%DateTuple{day: day}) when is_nil(day) do
      is_valid? Map.put(date_tuple, :day, 1)
    end

    def is_valid?(%DateTuple{year: year, month: month, day: day}) do
      case Date.new(year, month, day) do
        {:ok, _} ->
          true
        _ ->
          false
      end
    end

    def is_valid?(_),
      do: false
  end

  defimpl String.Chars, for: DateTuple do
    @doc """
    Convert a `DataSanitiser.DateUtils.DateTuple` to a string representation.

    If the day is `:nil` this will be formatted as `MM-YYYY` whilst if the day
    has a value it will be of the format `DD-MM-YYYY` (in both cases leading
    zeros are added if necessary).

    ## Examples
        iex> dt = %DataSanitiser.DateUtils.DateTuple{
        ...>        day: 1, month: 1, year: 2002
        ...>      }
        iex> to_string(dt)
        "01-01-2002"

        iex> dt = %DataSanitiser.DateUtils.DateTuple{month: 12, year: 2009}
        iex> to_string(dt)
        "12-2009"
    """
    @spec to_string(DateTuple.t) :: String.t
    def to_string(date_tuple)
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


  # List of lower cased months to be searched for in date strings.
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

  # Looks for dates of the form <day><separator><month><separator><year>
  # separators may be one of '-', '/' or ' '.
  # the day is optional and may be one or two digits (the double question
  #   mark after the day component ensures this is grabbed in a non-greedy
  #   way in order to make this optional).
  # the month is mandatory and may be one or two digits or a string matching
  #   a list of recognised months.
  # the year is optional and may be any two digits or four digits that start
  #   with 19 or 20.
  # The pattern must match the entire string given to it.
  @date_regex [
    "^",
    "(?:(?<day>\\d?\\d)?[-/ ])??",
    "(?<month>#{Enum.join Map.keys(@recognised_months), "|"}|\\d?\\d)",
    "[-/ ]?(?<year>(19|20)?\\d\\d)?",
    "$"
  ] |> Enum.join |> Regex.compile!

  # Various regular expressions for finding a number that could be a year in
  # a string.
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


  @doc """
  Convert a representation of a day to an integer between 1 and 31

  If the representation passed in cannot be converted simply to an integer
  between 1 and 31 then returns `:nil`, thus providing some very basic
  validity checking on the value provided.

  ## Examples
      iex> DataSanitiser.DateUtils.normalise_day("13")
      13
      iex> DataSanitiser.DateUtils.normalise_day(31)
      31
      iex> DataSanitiser.DateUtils.normalise_day("3")
      3
      iex> DataSanitiser.DateUtils.normalise_day("03")
      3
      iex> DataSanitiser.DateUtils.normalise_day("33")
      :nil
  """
  @spec normalise_day(String.t | integer) :: 1..31 | :nil
  def normalise_day(day)
  def normalise_day(""),
    do: :nil

  def normalise_day(day) when is_binary(day) do
    normalise_day String.to_integer day
  end

  def normalise_day(day) when day > 0 and day < 32,
    do: day
  def normalise_day(_),
    do: :nil 


  @doc """
  Convert a representation of a month to an integer between 1 and 12

  If the representation passed in cannot be converted simply to an integer
  between 1 and 12 then returns `:nil`, thus providing some very basic
  validity checking on the value provided.
  Conversions will also check against a list of known month names as well
  as straight integer representations.

  ## Examples
      iex> DataSanitiser.DateUtils.normalise_month("January")
      1
      iex> DataSanitiser.DateUtils.normalise_month("dec")
      12
      iex> DataSanitiser.DateUtils.normalise_month(1)
      1
      iex> DataSanitiser.DateUtils.normalise_month("05")
      5
      iex> DataSanitiser.DateUtils.normalise_month("73")
      :nil
  """
  @spec normalise_month(String.t | integer) :: 1..12 | :nil
  def normalise_month(month) when is_binary(month) do
    case Integer.parse month do
      :error ->
        Map.get @recognised_months, String.downcase(month)
      {month_integer, ""} ->
        normalise_month month_integer
    end
  end

  def normalise_month(month) when month > 0 and month < 13,
    do: month
  def normalise_month(_),
    do: :nil


  @doc """
  Convert a representation of a year to an integer

  If the representation passed in cannot be converted simply to an integer
  then returns `:nil`, thus providing some very basic validity checking on
  the value provided.
  If the value would have come out as being less than 100 it will switched
  to either the 20th or 21st century (whichever is greater without putting
  it into the future)

  ## Examples
      iex> DataSanitiser.DateUtils.normalise_year("1905")
      1905
      iex> DataSanitiser.DateUtils.normalise_year("99")
      1999
      iex> DataSanitiser.DateUtils.normalise_year(1)
      2001
      iex> DataSanitiser.DateUtils.normalise_year("05")
      2005
      iex> DataSanitiser.DateUtils.normalise_year(2345)
      2345
      iex> DataSanitiser.DateUtils.normalise_year("")
      :nil
  """
  @spec normalise_year(String.t | integer) :: integer | :nil
  def normalise_year(year)
  def normalise_year(""),
    do: :nil

  def normalise_year(year) when is_binary(year) do
    normalise_year String.to_integer(year)
  end

  def normalise_year(year) when year < 100 do
    normalise_year(year + 2000, :past_only)
  end

  def normalise_year(year),
    do: year

  def normalise_year(year, :past_only) do
    current_year = DateTime.utc_now.year
    cond do
      year > current_year -> year - 100
      true -> year
    end
  end


  @spec parse_date_string(String.t) :: {
    1..31 | :nil,
    1..12 | :nil,
    pos_integer | :nil
  }
  defp parse_date_string(date_string) do
    # Runs the date string through the date matching expression.
    # Returns a tuple of normalised versions of the components if there was a
    #  match.
    # Returns a tuple of 3 `:nil`s if there was no match.
    case Regex.named_captures @date_regex, String.downcase(date_string) do
      %{"day" => day, "month" => month, "year" => year}
        -> {normalise_day(day), normalise_month(month), normalise_year(year)}
      _
        -> {:nil, :nil, :nil}
    end
  end


  @doc """
  Convert a string into a `DataSanitiser.DateUtils.DateTuple`.

  Attempts to extract day/month/year components from the string provided.
  If there is no month component will return an empty map, otherwise
  if there is no year component it will substitute the default year passed
  in.
  """
  @spec date_string_to_tuple(String.t, pos_integer | :nil) :: DateTuple.t
  def date_string_to_tuple(date_string, default_year) do
    case parse_date_string date_string do
      {_, :nil, _}
        -> %DateTuple{day: :nil, month: :nil, year: :nil}
      {day, month, :nil}
        -> %DateTuple{day: day, month: month, year: default_year}
      {day, month, year}
        -> %DateTuple{day: day, month: month, year: year}
    end
  end


  @doc """
  Try to pull a single year from a string

  If multiple years are detected then returns `:ambiguous`, if no years
  are detected then returns `:nil` otherwise returns the year having first
  passed it through `DataSanitiser.DateUtils.normalise_year/1`

  ## Examples
      iex> string = "Let's party like it's 1999"
      iex> DataSanitiser.DateUtils.extract_year_from_string(string)
      1999

      iex> string = "Data from '95"
      iex> DataSanitiser.DateUtils.extract_year_from_string(string)
      1995

      iex> string = "Data from '95"
      iex> DataSanitiser.DateUtils.extract_year_from_string(string)
      1995

      iex> string = "2004 may also be known as '04"
      iex> DataSanitiser.DateUtils.extract_year_from_string(string)
      2004

      iex> string = "Looking forward to 2021"
      iex> DataSanitiser.DateUtils.extract_year_from_string(string)
      2021

      iex> string = "94 to 95 is a range"
      iex> DataSanitiser.DateUtils.extract_year_from_string(string)
      :ambiguous

      iex> string = "Twenty Twelve isn't an integer"
      iex> DataSanitiser.DateUtils.extract_year_from_string(string)
      :nil
  """
  @spec extract_year_from_string(String.t) :: pos_integer | :ambiguous | :nil
  def extract_year_from_string(string) when is_binary(string) do
    years = @year_regular_expressions
            |> Stream.flat_map(&(scan_and_flatten &1, string))
            |> Stream.map(&String.to_integer/1)
            |> Stream.map(&normalise_year/1)
            |> Enum.dedup
    case years do
      [year] ->
        year
      [] ->
        :nil
      _ ->
        :ambiguous
    end
  end


  @spec scan_and_flatten(Regex.t, String.t) :: [String.t]
  defp scan_and_flatten(regex, string) do
    # Find all the matches of a regular expression in a string and flatten
    # the list of results before returning them.
    regex
    |> Regex.scan(string, capture: :all_but_first)
    |> List.flatten
  end
end
