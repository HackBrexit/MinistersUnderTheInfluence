require 'rails_helper'

RSpec.describe "Meetings", type: :request do
  before(:each){create(:meeting)}
  let(:source_file){Meeting.last.source_file}
  describe "GET /meetings" do
    it "should return 200" do
      get meetings_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /meetings" do
    let(:json_api_data) do
      {
        "data" =>  {
          "type" =>  "meetings",
          "attributes" =>  {
            "purpose" =>  "A test meeting",
            "year" => '2016',
            "month" => '3',
            "source-file-id" => source_file.id,
            "source-file-line-number" => 1
          }
        }
      }.to_json
    end
    let(:headers){{'HTTP_ACCEPT' => "application/vnd.api+json",'Content-Type' => "application/vnd.api+json"}}

    it 'returns a 201' do
      post api_v1_meetings_path,params: json_api_data, headers:headers
      expect(response).to have_http_status(201)
    end

    it 'returns a json-api response' do
      post api_v1_meetings_path,params: json_api_data, headers:headers
      expect(response.body).to be_jsonapi_response_for('meetings')
    end

    it 'should create a meeting record' do
      expect{post api_v1_meetings_path,params: json_api_data, headers:headers}.to change(Meeting, :count).by 1
    end

    it 'should create a meeting record with the right data' do
      post api_v1_meetings_path,params: json_api_data, headers:headers
      meeting = Meeting.last
      expect(meeting.purpose).to eq 'A test meeting'
      expect(meeting.year).to eq 2016
      expect(meeting.month).to eq 3 
    end
  end
end
