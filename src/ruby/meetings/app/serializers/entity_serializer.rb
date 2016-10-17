class EntitySerializer < ActiveModel::Serializer
  attributes :id, :name, :wikipedia_entry, :type
end
