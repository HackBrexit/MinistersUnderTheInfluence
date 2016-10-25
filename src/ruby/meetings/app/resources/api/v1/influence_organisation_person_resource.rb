class Api::V1::InfluenceOrganisationPersonResource < Api::V1::InfluenceOfficePersonResource
  has_one :organisation,foreign_key: 'office_id',class: 'Organisation'
end
