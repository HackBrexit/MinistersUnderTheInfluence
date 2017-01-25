defmodule DataSanitiser.DateUtils do

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

  @date_regex ~r{^(?:(?<day>\d?\d)?[-/])??(?<month>#{Enum.join Map.keys(@recognised_months), "|"}|\d?\d)[-/]?(?<year>(19|20)?\d\d)?$}
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


  defp normalise_day(""), do: :nil
  defp normalise_day(day), do: String.to_integer day


  defp normalise_month(month) when is_binary(month) do
    Map.get @recognised_months, String.downcase(month) 
  end
  defp normalise_month(month) when month > 0 and month < 13, do: month
  defp normalise_month(_), do: :nil


  defp normalise_year(""), do: :nil
  defp normalise_year(year) when is_binary(year), do: normalise_year String.to_integer(year)
  defp normalise_year(year) when year < 100, do: normalise_year(year + 2000)
  defp normalise_year(year) do
    current_year = DateTime.utc_now.year
    cond do
      year > current_year -> year - 100
      true -> year
    end
  end


  defp parse_date_string(date_string) do
    case Regex.named_captures @date_regex, String.downcase(date_string) do
    %{ "day" => day, "month" => month, "year" => year }
      -> { normalise_day(day), normalise_month(month), normalise_year(year) }
    _
      -> { :nil, :nil, :nil }
    end
  end


  def date_string_to_tuple(date_string, default_year) do
    case parse_date_string date_string do
    { _, :nil, _ }
      -> %{ day: :nil, month: :nil, year: :nil }
    { day, month, :nil }
      -> %{ day: day, month: month, year: default_year }
    { day, month, year }
      -> %{ day: day, month: month, year: year }
    end
  end


  def extract_year_from_string(string) when is_binary(string) do
    years = @year_regular_expressions
            |> Stream.flat_map(&(scan_and_flatten &1, string))
            |> Stream.map(&String.to_integer/1)
            |> Enum.map(&normalise_year/1)
    case years do
    [ year ] ->
      year
    [] ->
      :nil
    _ -> :ambiguous
    end
  end


  defp scan_and_flatten(regex, string) do
    regex
    |> Regex.scan(string, capture: :all_but_first)
    |> List.flatten
  end
end
