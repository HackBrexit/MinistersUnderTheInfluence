class InfluenceOrganisationPerson < InfluenceOfficePerson
  belongs_to :organisation,foreign_key: 'office_id'
end
