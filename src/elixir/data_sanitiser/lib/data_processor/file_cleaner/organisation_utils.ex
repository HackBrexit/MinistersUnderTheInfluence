defmodule DataProcessor.FileCleaner.OrganisationUtils do
  @separator_regex ~R{,|;| and | & |/|\\}


  def parse_organisations(organisations_string) do
    organisations_string
    |> String.split(@separator_regex)
    |> Enum.map(&String.trim/1)
  end
end
