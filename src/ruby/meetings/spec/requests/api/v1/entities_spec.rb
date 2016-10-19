require 'rails_helper'

RSpec.describe "Entities", type: :request do
  describe "GET /entities" do
    it "works! (now write some real specs)" do
      get entities_path
      expect(response).to have_http_status(200)
    end
  end
end
