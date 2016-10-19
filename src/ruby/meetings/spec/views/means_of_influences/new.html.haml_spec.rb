require 'rails_helper'

RSpec.describe "means_of_influences/new", type: :view do
  before(:each) do
    assign(:means_of_influence, MeansOfInfluence.new(
      :day => 1,
      :month => 1,
      :year => 1,
      :purpose => "MyString",
      :type_of_hospitality => "MyString",
      :gift => "MyString",
      :value => 1
    ))
  end

  it "renders new means_of_influence form" do
    render

    assert_select "form[action=?][method=?]", means_of_influences_path, "post" do

      assert_select "input#means_of_influence_day[name=?]", "means_of_influence[day]"

      assert_select "input#means_of_influence_month[name=?]", "means_of_influence[month]"

      assert_select "input#means_of_influence_year[name=?]", "means_of_influence[year]"

      assert_select "input#means_of_influence_purpose[name=?]", "means_of_influence[purpose]"

      assert_select "input#means_of_influence_type_of_hospitality[name=?]", "means_of_influence[type_of_hospitality]"

      assert_select "input#means_of_influence_gift[name=?]", "means_of_influence[gift]"

      assert_select "input#means_of_influence_value[name=?]", "means_of_influence[value]"
    end
  end
end
