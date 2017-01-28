defmodule DataSanitiser.CSVCleaner do
  NimbleCSV.define(CSVParser, separator: ",", escape: "\"")

  alias DataSanitiser.DataFile.MeetingRow
  alias DataSanitiser.DateUtils
  alias DataSanitiser.OrganisationUtils
  alias DataSanitiser.Canonicaliser

  @header_types %{
    "organisation" => :organisations,
    "minister" => :minister,
    "date" => :date,
    "reason" => :reason,
    "purpose" => :reason
  }


  defmodule RowState do
    defstruct previous_minister: :nil, data_positions: :nil
  end


  def clean_file(file_metadata=%{data_type: :meetings}) do
    processed_rows = file_metadata.filename
                     |> File.stream!
                     |> Stream.map(&(:unicode.characters_to_binary(&1, :latin1)))
                     |> Stream.flat_map(&(String.split &1, "\r"))
                     |> CSVParser.parse_stream(headers: :false)
                     |> Stream.with_index
                     |> Stream.transform(:header, &(clean_meeting_row &1, &2, file_metadata))
                     |> Stream.filter(&MeetingRow.is_valid?/1)

    new_metadata = Map.put(file_metadata, :rows, processed_rows)
    {:ok, new_metadata}
  end

  def clean_file(file_metadata) do
    {:error, :unsupported_data_type, file_metadata}
  end


  defp clean_meeting_row(row, :header, _file_metadata) do
    data_positions = meeting_data_positions_from_header row
    {[:nil], %RowState{data_positions: data_positions}}
  end

  defp clean_meeting_row({csv_row, row_index}, row_state, file_metadata) do
    case fetch_meeting_values_from_row(csv_row, row_state) do
    %{minister: "", date: "", organisations: "", reason: ""} ->
      {[:nil], row_state}
    %{minister: minister, date: date, organisations: organisations, reason: reason} ->
      row = %MeetingRow{row: row_index}
            |> parse_and_insert_minister(String.trim(minister), row_state)
            |> parse_and_insert_date(date, file_metadata.year)
            |> parse_and_insert_reason(reason)
            |> parse_and_insert_organisations(organisations)
      {[row], Map.put(row_state, :previous_minister, row.minister)}
    _ ->
      if row_is_empty? csv_row do
        {[:nil], row_state}
      else
        {[{:error, :invalid_row, row_index}], row_state}
      end
    end
  end


  defp meeting_data_positions_from_header({header_row, _}) do
    Enum.map header_row, &(extract_column_type String.trim(&1))
  end


  defp extract_column_type(""), do: :empty

  defp extract_column_type(header_value) do
    extract_column_type(header_value, Map.keys(@header_types))
  end

  defp extract_column_type(_header_value, []), do: :unknown

  defp extract_column_type(header_value, [type_key | remaining_types]) do
    key_matches = header_value
                  |> String.downcase
                  |> String.contains?(type_key)
    if key_matches do
      @header_types[type_key]
    else
      extract_column_type(header_value, remaining_types)
    end
  end


  defp fetch_meeting_values_from_row(csv_row, row_state) do
    row_state.data_positions
    |> Enum.zip(csv_row)
    |> Enum.into(%{})
  end


  defp row_is_empty?(csv_row), do: Enum.all? csv_row, &(""  == String.trim &1)


  defp parse_and_insert_minister(row, "", %RowState{previous_minister: minister}) do
    Map.put(row, :minister, clean_minister_name(minister))
  end

  defp parse_and_insert_minister(row, minister, _) do
    Map.put(row, :minister, clean_minister_name(minister))
  end


  defp clean_minister_name(:nil), do: :nil
  defp clean_minister_name(minister) do
    minister
    |> String.replace(~r{^.* Rt Hon}, "Rt Hon")
    |> String.replace(~r{ MP[ ,].*$}, " MP")
    |> String.replace(~r{\(.*\)}, "")
    |> trim_spaces_and_commas
    |> Canonicaliser.canonicalise
  end


  defp parse_and_insert_reason(row, reason) do
    Map.put(row, :reason, clean_reason(reason))
  end


  defp trim_spaces_and_commas(string) do
    string
    |> String.trim
    |> String.trim(",")
    |> String.trim
  end


  defp clean_reason(reason) do
    reason
    |> trim_spaces_and_commas
    |> Canonicaliser.canonicalise
  end


  defp parse_and_insert_date(row, date_string, default_year) do
    date_tuple = DateUtils.date_string_to_tuple date_string, default_year
    row
    |> Map.put(:start_date, date_tuple)
    |> Map.put(:end_date, date_tuple)
  end


  defp parse_and_insert_organisations(row, organisations_string) do
    organisations = OrganisationUtils.parse_organisations(organisations_string)
                    |> Stream.map(&clean_organisation_name/1)
    Map.put(row, :organisations, organisations)
  end


  defp clean_organisation_name(name) do
    name
    |> trim_spaces_and_commas
    |> Canonicaliser.canonicalise
  end
end
