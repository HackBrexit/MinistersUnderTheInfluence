class InfluenceGovernmentOfficePerson < InfluenceOfficePerson
  belongs_to :government_office, foreign_key: 'office_id'
end
