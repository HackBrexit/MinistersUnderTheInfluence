defmodule DataSanitiser.OrganisationUtils do
  @moduledoc """
  Functions for dealing with organisations.
  """

  alias DataSanitiser.Canonicaliser
  import DataSanitiser.GeneralUtils, only: [trim_spaces_and_commas: 1]

  @separators [
    ",",
    ";",
    " and ",
    " & ",
    "/",
    "\\\\", # Actually just a single \ but needs to be double escaped
    "\\n"
  ]
  @separator_regex ~r{#{Enum.join @separators, "|"}}


  @doc """
  Convert a string of organisations into a list of them.

  Currently does a very crude conversion by first splitting on 
  #{Enum.join @separators, ","}
  After that resulting strings have leading/trailing whitespace and commas
  removed, empty strings are filtered out and the canonical versions of the
  strings are looked up.

  ## Examples
      iex> import DataSanitiser.OrganisationUtils,
      ...>   only: [parse_organisations: 1]
      iex> parse_organisations("ORG1, Org 2, orG 3")
      ["ORG1", "Org 2", "orG 3"]
      iex> parse_organisations("ORG 3, org1, org 4")
      ["orG 3", "ORG1", "org 4"]
  """
  @spec parse_organisations(String.t) :: [String.t]
  def parse_organisations(organisations_string) do
    organisations_string
    |> String.split(@separator_regex)
    |> Stream.map(&trim_spaces_and_commas/1)
    |> Stream.reject(&(&1 == ""))
    |> Enum.map(&Canonicaliser.canonicalise/1)
  end
end
