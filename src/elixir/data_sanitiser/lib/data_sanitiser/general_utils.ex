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


  @doc """
  Try to reduce a list of values to a single one by removing duplicates.

  Returns :nil if the enumerable is empty, `:ambiguous` if either one of the
  entries in the list is `:ambiguous` or if there is more than one (non-nil)
  value in the enumerable. If there is only one (non-nil) value in the
  enumerable then that will be returned.

  ## Examples
      iex> import DataSanitiser.GeneralUtils, only: [reduce_to_single_value: 1]
      iex> reduce_to_single_value([1,1,1])
      1
      iex> reduce_to_single_value([])
      :nil
      iex> reduce_to_single_value([:nil, :nil, 2])
      2
      iex> reduce_to_single_value([1,2,3])
      :ambiguous
      iex> reduce_to_single_value([1,1,:ambiguous])
      :ambiguous
  """
  @spec reduce_to_single_value(list) :: any | :nil | :ambiguous
  def reduce_to_single_value(list)
  def reduce_to_single_value([]),
    do: :nil
  def reduce_to_single_value([head | tail]),
    do: do_reduce_to_single_value tail, head

  defp do_reduce_to_single_value([], value),
    do: value
  defp do_reduce_to_single_value([value | tail], value),
    do: do_reduce_to_single_value tail, value
  defp do_reduce_to_single_value([value | tail], :nil),
    do: do_reduce_to_single_value tail, value
  defp do_reduce_to_single_value([:nil | tail], value),
    do: do_reduce_to_single_value tail, value
  defp do_reduce_to_single_value([:ambiguous | _tail], _value),
    do: :ambiguous
  defp do_reduce_to_single_value([_head | _tail], _value), do:
    :ambiguous
end
