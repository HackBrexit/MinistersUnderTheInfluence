class InfluenceGovernmentOfficePerson < InfluenceOfficePerson
  belongs_to :government_office, foreign_key: 'office_id'
  belongs_to :government_person, class_name: 'Person', foreign_key: 'person_id'
end
