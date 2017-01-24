defmodule FileCleaner.Canonicaliser do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  
  def canonicalise(value) do
    key = String.downcase value
    GenServer.call(__MODULE__, {key, value})
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
