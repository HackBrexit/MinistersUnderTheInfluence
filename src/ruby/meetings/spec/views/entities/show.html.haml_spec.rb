require 'rails_helper'

RSpec.describe "entities/show", type: :view do
  before(:each) do
    @entity = create(:person)
  end
  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Wikipedia Entry/i)
  end
end
