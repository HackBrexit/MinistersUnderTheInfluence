require 'rails_helper'

  RSpec.describe MeansOfInfluence, type: :model do
    it{ should have_db_column(:type).of_type(:string)}
    it{ should have_db_column(:day).of_type(:integer)}
    it{ should have_db_column(:month).of_type(:integer)}
    it{ should have_db_column(:year).of_type(:integer)}
    it{ should validate_presence_of(:year)}
    it{ should validate_presence_of(:month)}
    it{ should have_many(:influence_government_office_people)}
    it{ should have_many(:influence_organisation_people)}
    it{ should have_many(:organisations).through(:influence_organisation_people)}
    it{ should have_many(:government_people).through(:influence_government_office_people).class_name('Person')}
    it{ should have_many(:government_offices).through(:influence_government_office_people)}
    it{ should have_many(:organisation_people).through(:influence_organisation_people).class_name('Person')}
    it{ should belong_to(:source_file)}
    it{ should have_db_column(:source_file_id).of_type(:integer)}
    it{ should have_db_column(:source_file_line_number).of_type(:integer)}
    it{ should validate_presence_of(:source_file_id)}
    it{ should validate_presence_of(:source_file_line_number)}
  end


RSpec.describe Meeting, type: :model do
  it{ should have_db_column(:purpose).of_type(:string)}

  # verify that these complex through relationships are working
  it 'should link to a government person' do
   link_record = create(:influence_government_office_person)
   meeting = link_record.meeting
   expect(meeting.government_people).not_to be_empty
  end

  it 'should link to a government office' do
   link_record = create(:influence_government_office_person)
   meeting = link_record.meeting
   expect(meeting.government_offices).not_to be_empty
  end

  it 'should link to organisations' do
   link_record = create(:influence_organisation_person)
   meeting = link_record.meeting
   expect(meeting.organisations).not_to be_empty
  end

  it 'should link to organisations' do
   link_record = create(:influence_organisation_person)
   meeting = link_record.meeting
   expect(meeting.organisation_people).not_to be_empty
  end
end

RSpec.describe Travel, type: :model do
  it{ should have_db_column(:purpose).of_type(:string)}
  it{should validate_presence_of(:purpose)}
end

RSpec.describe Hospitality, type: :model do
  it{ should have_db_column(:type_of_hospitality).of_type(:string)}
  it{should validate_presence_of(:type_of_hospitality)}
end

RSpec.describe Gift, type: :model do
  it{ should have_db_column(:gift).of_type(:string)}
  it{should validate_presence_of(:gift)}
end
RSpec.describe MeansOfInfluence,type: :model do
  context 'the class' do
    subject{MeansOfInfluence}
    MeansOfInfluence.types.each do |influence_type|
      it { should have_scope(influence_type.underscore.downcase.pluralize)}
    end
  end
end
