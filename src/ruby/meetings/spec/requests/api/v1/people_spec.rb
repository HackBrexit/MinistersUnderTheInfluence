require 'rails_helper'

RSpec.describe "Api::V1::People", type: :request do
  describe "GET /api/v1/people" do
    let(:person){create(:person)}
    let(:headers){{'HTTP_ACCEPT' => "application/vnd.api+json"}}
    it "it returns a 200" do
      get api_v1_person_path(person),headers: headers
      expect(response).to have_http_status(200)
    end

    it 'should be a json-api response' do
      get api_v1_person_path(person),headers: headers
      expect(response.body).to be_jsonapi_response_for('people')
    end

    it 'should allow filtering by name' do
      people = create_list(:person,3)
      last_person = people.last
      get api_v1_people_path, params: {'filter[name]'=>last_person.name}, headers: headers
      person_json = JSON.parse(response.body)
      expect(person_json['data'].size).to eq(1)
    end
  end

  describe "POST /api/v1/people" do
    let(:json_api_data) do
      {
        "data" =>  {
          "type" =>  "people",
          "attributes" =>  {
            "name" =>  "Ember Hamster2",
            "wikipedia-entry" =>  "an entry" 
          }
        }
      }.to_json
    end
    let(:headers){{'HTTP_ACCEPT' => "application/vnd.api+json",'Content-Type' => "application/vnd.api+json"}}

    it 'returns a 201' do
      post api_v1_people_path,params: json_api_data,headers: headers
      expect(response).to have_http_status(201)
    end

    it 'returns a json-api response' do
      post api_v1_people_path,params: json_api_data, headers: headers
      expect(response.body).to be_jsonapi_response_for('people')
    end
  end

  describe "PATCH /api/v1/people/{id}" do
    let(:headers){{'HTTP_ACCEPT' => "application/vnd.api+json",'Content-Type' => "application/vnd.api+json"}}
    let(:person){create(:person)}
    let(:json_api_data) do
      {
        "data" =>  {
          "type" =>  "people",
          "id" => person.id,
          "attributes" =>  {
            "name" =>  "kjkjkjkj",
            "wikipedia-entry" =>  "jkj entry" 
          }
        }
      }.to_json
    end
    it 'returns a 200' do
      patch api_v1_person_path(person),params: json_api_data,headers: headers
      expect(response).to have_http_status(200)
    end
    it 'returns a json-api response' do
      patch api_v1_person_path(person),params: json_api_data, headers: headers
      expect(response.body).to be_jsonapi_response_for('people')
    end
    it 'updates the data' do
      patch api_v1_person_path(person),params: json_api_data, headers: headers
      p = Person.find person.id
      expect(p.name).to eq("kjkjkjkj")
      expect(p.wikipedia_entry).to eq("jkj entry")
    end
  end
end
