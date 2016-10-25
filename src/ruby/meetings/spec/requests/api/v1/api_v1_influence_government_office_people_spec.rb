require 'rails_helper'

RSpec.describe "Api::V1::InfluenceGovernmentOfficePeople", type: :request do
  describe "GET /api/v1/influence_government_office_people" do
    it "returns a 200" do
      create(:influence_government_office_person)
      get api_v1_influence_government_office_people_path,headers:{'HTTP_ACCEPT' => "application/vnd.api+json"}
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /api/v1/influence_government_office_people" do
    let(:headers){{'HTTP_ACCEPT' => "application/vnd.api+json",'Content-Type' => "application/vnd.api+json"}}
    let(:government_person){create(:person)}
    let(:government_office){create(:government_office)}
    let(:meeting){create(:meeting)}
    let(:json_data) do
      {
        "data" =>  {
          "type" =>  "influence-government-office-people",
          "relationships" =>{
            "meeting"=>{"data"=>{"type"=>"meetings","id"=>meeting.id}},
             "government-office"=>{"data"=>{"type"=>"government-offices","id"=>government_office.id}},
             "person"=>{"data"=>{"type"=>"people","id"=>government_person.id}}
          }
        }
      }.to_json
    end
    it "should return 201" do
      post api_v1_influence_government_office_people_path,params: json_data, headers: headers
      expect(response).to have_http_status(201)
    end
  end
end
