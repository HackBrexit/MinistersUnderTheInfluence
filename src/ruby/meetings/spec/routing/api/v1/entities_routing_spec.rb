require "rails_helper"

RSpec.describe Api::V1::EntitiesController, type: :routing do
  describe "routing" do


    context 'types' do
      Entity.types.each do |entity_type|
        it "routes #{entity_type} to #index" do
          expect(:get => "/api/v1/#{entity_type.pluralize.underscore.dasherize.downcase}").to route_to("api/v1/#{entity_type.pluralize.underscore.downcase}#index")
        end

        it "routes api/v1/#{entity_type} to #show" do
          expect(:get => "/api/v1/#{entity_type.pluralize.underscore.dasherize.downcase}/1").to route_to("api/v1/#{entity_type.pluralize.underscore.downcase}#show", :id => "1")
        end

        it "routes api/v1/#{entity_type} to #create" do
          expect(:post => "/api/v1/#{entity_type.pluralize.underscore.dasherize.downcase}").to route_to("api/v1/#{entity_type.pluralize.underscore.downcase}#create")
        end

        it "routes api/v1/#{entity_type} to #update via PUT" do
          expect(:put => "/api/v1/#{entity_type.pluralize.underscore.dasherize.downcase}/1").to route_to("api/v1/#{entity_type.pluralize.underscore.downcase}#update", :id => "1")
        end

        it "routes api/v1/#{entity_type} to #update via PATCH" do
          expect(:patch => "/api/v1/#{entity_type.pluralize.underscore.dasherize.downcase}/1").to route_to("api/v1/#{entity_type.pluralize.underscore.downcase}#update", :id => "1")
        end

        it "routes api/v1/#{entity_type} to #destroy" do
          expect(:delete => "/api/v1/#{entity_type.pluralize.underscore.dasherize.downcase}/1").to route_to("api/v1/#{entity_type.pluralize.underscore.downcase}#destroy", :id => "1")
        end

      end
    end

  end
end
