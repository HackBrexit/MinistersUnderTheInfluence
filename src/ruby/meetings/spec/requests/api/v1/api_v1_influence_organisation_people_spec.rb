require 'rails_helper'

RSpec.describe "Api::V1::InfluenceOrganisationPeople", type: :request do
  describe "GET /api_v1_influence_organisation_people" do
    it "works! (now write some real specs)" do
      create(:influence_organisation_person)
      get api_v1_influence_organisation_people_path,headers:{'HTTP_ACCEPT' => "application/vnd.api+json"}
      expect(response).to have_http_status(200)
    end
  end
  describe "POST /api/v1/influence_organisation_people" do
    let(:headers){{'HTTP_ACCEPT' => "application/vnd.api+json",'Content-Type' => "application/vnd.api+json"}}
    let(:person){create(:person)}
    let(:organisation){create(:organisation)}
    let(:meeting){create(:meeting)}
    let(:json_data) do
      {
        "data" =>  {
          "type" =>  "influence-organisation-people",
          "relationships" =>{
            "meeting"=>{"data"=>{"type"=>"meetings","id"=>meeting.id}},
            "organisation"=>{"data"=>{"type"=>"organisations","id"=>organisation.id}},
            "person"=>{"data"=>{"type"=>"people","id"=>person.id}}
          }
        }
      }.to_json
    end
    it "should return 201" do
      post api_v1_influence_organisation_people_path,params: json_data, headers: headers
      expect(response).to have_http_status(201)
    end
  end
end
