class Api::V1::EntityResource < JSONAPI::Resource
  attributes :name,:wikipedia_entry

  filter :name
end
