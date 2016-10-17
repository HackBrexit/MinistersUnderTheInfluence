class Api::V1::PersonResource < Api::V1::EntityResource
  has_many :meetings
end
