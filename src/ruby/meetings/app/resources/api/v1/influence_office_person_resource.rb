class Api::V1::InfluenceOfficePersonResource < JSONAPI::Resource
  has_one :meeting,foreign_key: 'means_of_influence_id',class: 'Meeting'
  has_one :hospitality,foreign_key: 'means_of_influence_id',class: 'Hospitality'
  has_one :gift,foreign_key: 'means_of_influence_id',class: 'Gift'
  has_one :travel,foreign_key: 'means_of_influence_id',class: 'Travel'
  has_one :person
end
