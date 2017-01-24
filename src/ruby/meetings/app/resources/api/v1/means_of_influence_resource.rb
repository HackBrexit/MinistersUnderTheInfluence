class Api::V1::MeansOfInfluenceResource < JSONAPI::Resource
  # attributes :year,:month,:source_file_id,:source_file_line_number
  attributes :year, :month, :day, :source_file_id, :source_file_line_number
  has_one :source_file
end
