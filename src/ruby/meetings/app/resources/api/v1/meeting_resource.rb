class Api::V1::MeetingResource < Api::V1::MeansOfInfluenceResource
  attributes :purpose
  has_many :organisations
  has_many :organisation_people
  has_many :government_people
  has_many :government_offices
end
