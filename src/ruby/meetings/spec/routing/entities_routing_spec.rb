require "rails_helper"

RSpec.describe EntitiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/entities").to route_to("entities#index")
    end

    it "routes to #new" do
      expect(:get => "/entities/new").to route_to("entities#new")
    end

    it "routes to #show" do
      expect(:get => "/entities/1").to route_to("entities#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/entities/1/edit").to route_to("entities#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/entities").to route_to("entities#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/entities/1").to route_to("entities#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/entities/1").to route_to("entities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/entities/1").to route_to("entities#destroy", :id => "1")
    end

    context 'types' do
      Entity.types.each do |entity_type|
        it "routes #{entity_type} to #index" do
          expect(:get => "/#{entity_type.pluralize.underscore.downcase}").to route_to("entities#index", type: entity_type)
        end

        it "routes #{entity_type} to #new" do
          expect(:get => "/#{entity_type.pluralize.underscore.downcase}/new").to route_to("entities#new", type: entity_type)
        end

        it "routes #{entity_type} to #show" do
          expect(:get => "/#{entity_type.pluralize.underscore.downcase}/1").to route_to("entities#show", :id => "1", type: entity_type)
        end

        it "routes #{entity_type} to #edit" do
          expect(:get => "/#{entity_type.pluralize.underscore.downcase}/1/edit").to route_to("entities#edit", :id => "1", type: entity_type)
        end

        it "routes #{entity_type} to #create" do
          expect(:post => "/#{entity_type.pluralize.underscore.downcase}").to route_to("entities#create", type: entity_type)
        end

        it "routes #{entity_type} to #update via PUT" do
          expect(:put => "/#{entity_type.pluralize.underscore.downcase}/1").to route_to("entities#update", :id => "1", type: entity_type)
        end

        it "routes #{entity_type} to #update via PATCH" do
          expect(:patch => "/#{entity_type.pluralize.underscore.downcase}/1").to route_to("entities#update", :id => "1", type: entity_type)
        end

        it "routes #{entity_type} to #destroy" do
          expect(:delete => "/#{entity_type.pluralize.underscore.downcase}/1").to route_to("entities#destroy", :id => "1", type: entity_type)
        end

      end
    end

  end
end
