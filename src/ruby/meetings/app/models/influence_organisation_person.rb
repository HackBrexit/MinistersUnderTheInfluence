class InfluenceOrganisationPerson < InfluenceOfficePerson
  belongs_to :organisation,foreign_key: 'office_id'
  belongs_to :organisation_person,class_name: 'Person',foreign_key: 'person_id'
end
