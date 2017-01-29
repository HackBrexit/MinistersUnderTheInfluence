defmodule DataSanitiser.OrganisationUtils do
  alias DataSanitiser.Canonicaliser
  import DataSanitiser.GeneralUtils, only: [trim_spaces_and_commas: 1]

  @separator_regex ~R{,|;| and | & |/|\\|\n}


  def parse_organisations(organisations_string) do
    organisations_string
    |> String.split(@separator_regex)
    |> Stream.map(&trim_spaces_and_commas/1)
    |> Stream.reject(&(&1 == ""))
    |> Enum.map(&Canonicaliser.canonicalise/1)
  end
end
