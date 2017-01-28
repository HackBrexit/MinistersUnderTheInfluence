defmodule DataSanitiser.OrganisationUtils do
  @separator_regex ~R{,|;| and | & |/|\\|\n}


  def parse_organisations(organisations_string) do
    organisations_string
    |> String.split(@separator_regex)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end
