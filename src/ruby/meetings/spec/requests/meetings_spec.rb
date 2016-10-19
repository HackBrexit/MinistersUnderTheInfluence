require 'rails_helper'

RSpec.describe "Meetings", type: :request do
  describe "GET /meetings" do
    it "" do
      get meetings_path
      expect(response).to have_http_status(200)
    end
  end
end
