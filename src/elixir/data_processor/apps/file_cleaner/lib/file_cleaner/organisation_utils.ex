defmodule FileCleaner.OrganisationUtils do
  @separator_regex ~R{,|;|and|&|/|\\}


  def parse_organisations(organisations_string) do
    if Regex.match? @separator_regex, organisations_string do
      :nil
    else
      [ String.trim organisations_string ]
    end
  end
end
