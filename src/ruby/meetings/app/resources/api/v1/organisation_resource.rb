class Api::V1::OrganisationResource < Api::V1::EntityResource
  has_many :meetings
end
