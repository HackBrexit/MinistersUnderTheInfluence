FactoryGirl.define do
  factory :influence_office_person do
    meeting
    factory :influence_government_office_person,class: InfluenceGovernmentOfficePerson do
      government_office
      association :government_person, factory: :person
    end
    factory :influence_organisation_person, class: InfluenceOrganisationPerson do
      organisation
      association :organisation_person, factory: :person
    end
  end
end
