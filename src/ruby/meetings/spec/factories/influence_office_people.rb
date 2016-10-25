FactoryGirl.define do
  factory :influence_office_person do
    meeting
    factory :influence_government_office_person,class: InfluenceGovernmentOfficePerson do
      government_office
      person
    end
    factory :influence_organisation_person, class: InfluenceOrganisationPerson do
      organisation
      person
    end
  end
end
