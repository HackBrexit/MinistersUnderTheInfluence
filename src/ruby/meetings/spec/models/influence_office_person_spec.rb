require 'rails_helper'

RSpec.describe InfluenceOfficePerson, type: :model do
  context 'the class' do
    subject{InfluenceOfficePerson}
    InfluenceOfficePerson.types.each do |iop_type|
      it { should have_scope(iop_type.underscore.downcase.pluralize)}
    end
  end
  it { should have_db_column(:means_of_influence_id).of_type(:integer)}
  it { should validate_presence_of(:means_of_influence_id)}
  it { should have_db_column(:type).of_type(:string)}
  it { should belong_to(:meeting).with_foreign_key(:means_of_influence_id)}
  it { should belong_to(:hospitality).with_foreign_key(:means_of_influence_id)}
  it { should belong_to(:gift).with_foreign_key(:means_of_influence_id)}
  it { should belong_to(:travel).with_foreign_key(:means_of_influence_id)}
end

RSpec.describe InfluenceGovernmentOfficePerson,type: :model do
  it { should belong_to(:government_person).class_name('Person').with_foreign_key('person_id')}
  it { should belong_to(:government_office).with_foreign_key('office_id')}
end

RSpec.describe InfluenceOrganisationPerson,type: :model do
  it { should belong_to(:organisation).with_foreign_key('office_id')}
  it { should belong_to(:organisation_person).class_name('Person').with_foreign_key('person_id')}
end
