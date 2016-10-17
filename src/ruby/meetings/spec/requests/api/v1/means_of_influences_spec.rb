require 'rails_helper'

RSpec.describe "MeansOfInfluences", type: :request do
  describe "GET /means_of_influences" do
    it "works! (now write some real specs)" do
      get means_of_influences_path
      expect(response).to have_http_status(200)
    end
  end
end
