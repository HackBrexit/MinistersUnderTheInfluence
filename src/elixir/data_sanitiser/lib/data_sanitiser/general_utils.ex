defmodule DataSanitiser.GeneralUtils do

  def trim_spaces_and_commas(string) do
    # Remove all whitespace and commas from the start and end
    Regex.replace(~r{(^[\s,]*)|([\s,]*$)}u, string,  "")
  end


  def put_into_map_at(value, map, key), do: Map.put map, key, value
end
