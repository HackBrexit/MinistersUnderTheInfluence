class Api::V1::InfluenceOfficePersonResource < JSONAPI::Resource
  has_one :meeting
  has_one :hospitality
  has_one :gift
  has_one :travel
end
