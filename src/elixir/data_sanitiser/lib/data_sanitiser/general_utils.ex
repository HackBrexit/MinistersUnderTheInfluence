defmodule DataSanitiser.GeneralUtils do
  @moduledoc """
  A collection of useful functions
  """

  @doc """
  Removes any leading or trailing whitespace and commas

  This is unicode compatible so it will remove non-breaking spaces
  and other forms of whitespace too that don't fit within ASCII.

  ## Examples
      iex> string = "  ,,  Important, here!  \\n"
      iex> DataSanitiser.GeneralUtils.trim_spaces_and_commas(string)
      "Important, here!"
      iex> DataSanitiser.GeneralUtils.trim_spaces_and_commas("All Good")
      "All Good"
  """
  @spec trim_spaces_and_commas(String.t) :: String.t
  def trim_spaces_and_commas(string) do
    Regex.replace(~r{(^[\s,]*)|([\s,]*$)}u, string,  "")
  end


  @doc """
  Reordered version of `Map.put` to assist with chaining

  Allows you to create a value with a chain of functions and end by
  inserting that value into a map.

  ## Example
      iex> import DataSanitiser.GeneralUtils, only: [put_into_map_at: 3]
      iex> "A VALUE" |> String.downcase |> put_into_map_at(%{}, :lower)
      %{lower: "a value"}
  """
  @spec put_into_map_at(Map.value, map, Map.key) :: map
  def put_into_map_at(value, map, key), do: Map.put map, key, value
end
