require 'rails_helper'

RSpec.describe "Offices", type: :request do
  describe "GET /offices" do
    it "it should return 200" do
      get api_v1_government_offices_path,headers:{'HTTP_ACCEPT' => "application/vnd.api+json"}
      expect(response).to have_http_status(200)
    end
  end
end
