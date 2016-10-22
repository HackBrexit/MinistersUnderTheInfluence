class Api::V1::InfluenceGovernmentOfficePersonResource < Api::V1::InfluenceOfficePersonResource
  has_one :government_office,foreign_key: 'office_id'
  has_one :government_person,foreign_key: 'person_id'
end
