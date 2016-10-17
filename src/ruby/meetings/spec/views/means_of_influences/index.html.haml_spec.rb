require 'rails_helper'

RSpec.describe "means_of_influences/index", type: :view do
  before(:each) do
    assign(:means_of_influences, [
      MeansOfInfluence.create!(
        :day => 2,
        :month => 3,
        :year => 4,
        :purpose => "Purpose",
        :type_of_hospitality => "Type Of Hospitality",
        :gift => "Gift",
        :value => 5
      ),
      MeansOfInfluence.create!(
        :day => 2,
        :month => 3,
        :year => 4,
        :purpose => "Purpose",
        :type_of_hospitality => "Type Of Hospitality",
        :gift => "Gift",
        :value => 5
      )
    ])
  end

  it "renders a list of means_of_influences" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Purpose".to_s, :count => 2
    assert_select "tr>td", :text => "Type Of Hospitality".to_s, :count => 2
    assert_select "tr>td", :text => "Gift".to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
