class GovernmentOffice < Entity
  # has_many :influence_government_office_people,-> { influence_government_office_people }, foreign_key: 'office_id',class_name:'InfluenceOfficePerson'
  has_many :influence_government_office_people, foreign_key: 'office_id'
  has_many :meetings,through: :influence_government_office_people,class_name: 'Meeting'
  has_many :hospitalities,through: :influence_government_office_people,class_name: 'Hospitality'
  has_many :gifts,through: :influence_government_office_people,class_name: 'Gift'
  has_many :travels,through: :influence_government_office_people,class_name: 'Travel'
end
