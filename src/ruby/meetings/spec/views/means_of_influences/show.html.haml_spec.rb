require 'rails_helper'

RSpec.describe "means_of_influences/show", type: :view do
  before(:each) do
    @means_of_influence = assign(:means_of_influence, MeansOfInfluence.create!(
      :day => 2,
      :month => 3,
      :year => 4,
      :purpose => "Purpose",
      :type_of_hospitality => "Type Of Hospitality",
      :gift => "Gift",
      :value => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Purpose/)
    expect(rendered).to match(/Type Of Hospitality/)
    expect(rendered).to match(/Gift/)
    expect(rendered).to match(/5/)
  end
end
