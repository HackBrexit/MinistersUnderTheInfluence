require 'rails_helper'

RSpec.describe SourceFile, type: :model do
  it {should have_db_column(:location).of_type(:string)}
  it {should have_db_column(:uri).of_type(:string)}
  it {should validate_presence_of(:location)}
  it {should validate_presence_of(:uri)}
  it {should have_many(:means_of_influences)}
end
