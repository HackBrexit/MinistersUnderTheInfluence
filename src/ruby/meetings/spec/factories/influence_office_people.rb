FactoryGirl.define do
  factory :influence_office_person do
    meeting
    person
    factory :influence_government_office_person,class: InfluenceGovernmentOfficePerson do
      government_office
    end
    factory :influence_organisation_person, class: InfluenceOrganisationPerson do
      organisation
    end
  end
end
