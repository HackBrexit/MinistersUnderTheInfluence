require 'rails_helper'

RSpec.describe "entities/new", type: :view do
  before(:each) do
    assign(:entity, Entity.new(
      :name => "MyString",
      :wikipedia_entry => "MyString"
    ))
  end

  it "renders new entity form" do
    render

    assert_select "form[action=?][method=?]", entities_path, "post" do

      assert_select "input#entity_name[name=?]", "entity[name]"

      assert_select "input#entity_wikipedia_entry[name=?]", "entity[wikipedia_entry]"

      assert_select "input#entity_type[name=?]", "entity[type]"
    end
  end
end
