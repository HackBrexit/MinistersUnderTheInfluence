require 'rails_helper'

RSpec.describe Entity, type: :model do
  it { should have_db_column(:type).of_type(:string) }
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:wikipedia_entry).of_type(:string) }
  it { should validate_presence_of(:name) }
end

RSpec.describe Person, type: :model do
  it { should have_many(:influence_office_people) }
  it { should have_many(:meetings).through(:influence_office_people) }
  it { should have_many(:hospitalities).through(:influence_office_people) }
  it { should have_many(:gifts).through(:influence_office_people) }
  it { should have_many(:travels).through(:influence_office_people) }
  it { should_not validate_uniqueness_of(:name) }
end

RSpec.describe Organisation, type: :model do
  it { should have_many(:influence_organisation_people) }
  it { should have_many(:meetings).through(:influence_organisation_people) }
  it { should have_many(:hospitalities).through(:influence_organisation_people) }
  it { should have_many(:gifts).through(:influence_organisation_people) }
  it { should have_many(:travels).through(:influence_organisation_people) }
  it { should validate_uniqueness_of(:name) }
end

RSpec.describe GovernmentOffice, type: :model do
  it { should have_many(:influence_government_office_people) }
  it { should have_many(:meetings).through(:influence_government_office_people) }
  it { should have_many(:hospitalities).through(:influence_government_office_people) }
  it { should have_many(:gifts).through(:influence_government_office_people) }
  it { should have_many(:travels).through(:influence_government_office_people) }
  it { should validate_uniqueness_of(:name) }
end

RSpec.describe Entity, type: :model do
  context 'the class' do
    subject{Entity}
    Entity.types.each do |entity_type|
      it { should have_scope(entity_type.underscore.downcase.pluralize)}
    end
  end
end
