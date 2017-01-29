defmodule DataSanitiser.Canonicaliser do
  @moduledoc """
  Provide a service for returning a canonical version of a string.
  """
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end


  @doc """
  Return the 'canonical' version of a string.

  Assumes that the first time a string is encountered it is the canonical
  way of casing that string and subsequent calls with different cased versions
  of the same string will result in the original string being returned.

  ## Examples
      iex> DataSanitiser.Canonicaliser.canonicalise("Test String 1")
      "Test String 1"
      iex> DataSanitiser.Canonicaliser.canonicalise("TEST STRING 1")
      "Test String 1"
      iex> DataSanitiser.Canonicaliser.canonicalise("TEST STRING 2")
      "TEST STRING 2"
      iex> DataSanitiser.Canonicaliser.canonicalise("Test STRING 1")
      "Test String 1"

      iex> DataSanitiser.Canonicaliser.canonicalise("Áççèñts wørk tôô")
      "Áççèñts wørk tôô"
      iex> DataSanitiser.Canonicaliser.canonicalise("ÁÇÇÈÑTS WØRK TÔÔ")
      "Áççèñts wørk tôô"
  """
  def canonicalise(string) do
    key = String.downcase string
    GenServer.call(__MODULE__, {key, string})
  end


  def init([]) do
    {:ok, %{}}
  end


  def handle_call({key, value}, _from, map) do
    case map[key] do
      :nil ->
        {:reply, value, Map.put(map, key, value)}
      canonical_value ->
        {:reply, canonical_value, map}
    end
  end
end
