defmodule DataSanitiser.GeneralUtils do

  def trim_spaces_and_commas(string) do
    # Remove all whitespace and commas from the start and end
    Regex.replace(~r{(^[\s,]*)|([\s,]*$)}u, string,  "")
  end
end
