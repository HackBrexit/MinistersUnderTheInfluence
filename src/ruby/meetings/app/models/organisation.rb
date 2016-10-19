class Organisation < Entity
  # has_many :influence_organisation_people,->{ influence_organisation_people },foreign_key: 'office_id',class_name:'InfluenceOfficePerson'
  has_many :influence_organisation_people,foreign_key: 'office_id'
  has_many :meetings,through: :influence_organisation_people,class_name: 'Meeting'
  has_many :hospitalities,through: :influence_organisation_people,class_name: 'Hospitality'
  has_many :gifts,through: :influence_organisation_people,class_name: 'Gift'
  has_many :travels,through: :influence_organisation_people,class_name: 'Travel'
end
