class MeansOfInfluenceSerializer < ActiveModel::Serializer
  attributes :id, :type, :day, :month, :year, :purpose, :type_of_hospitality, :gift, :value
end
