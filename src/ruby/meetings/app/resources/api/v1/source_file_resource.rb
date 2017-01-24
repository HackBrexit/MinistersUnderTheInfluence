class Api::V1::SourceFileResource < JSONAPI::Resource
  attributes :location,:uri
  has_many :means_of_influences
  has_many :meetings
  has_many :hospitalities
  has_many :travels
  has_many :gifts
end
