require "rails_helper"

RSpec.describe MeansOfInfluencesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/means_of_influences").to route_to("means_of_influences#index")
    end

    it "routes to #new" do
      expect(:get => "/means_of_influences/new").to route_to("means_of_influences#new")
    end

    it "routes to #show" do
      expect(:get => "/means_of_influences/1").to route_to("means_of_influences#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/means_of_influences/1/edit").to route_to("means_of_influences#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/means_of_influences").to route_to("means_of_influences#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/means_of_influences/1").to route_to("means_of_influences#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/means_of_influences/1").to route_to("means_of_influences#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/means_of_influences/1").to route_to("means_of_influences#destroy", :id => "1")
    end

    context 'types' do
      MeansOfInfluence.types.each do |means_of_influence_type|
        it "routes #{means_of_influence_type} to #index" do
          expect(:get => "/#{means_of_influence_type.pluralize.underscore.downcase}").to route_to("means_of_influences#index", type: means_of_influence_type)
        end

        it "routes #{means_of_influence_type} to #new" do
          expect(:get => "/#{means_of_influence_type.pluralize.underscore.downcase}/new").to route_to("means_of_influences#new", type: means_of_influence_type)
        end

        it "routes #{means_of_influence_type} to #show" do
          expect(:get => "/#{means_of_influence_type.pluralize.underscore.downcase}/1").to route_to("means_of_influences#show", :id => "1", type: means_of_influence_type)
        end

        it "routes #{means_of_influence_type} to #edit" do
          expect(:get => "/#{means_of_influence_type.pluralize.underscore.downcase}/1/edit").to route_to("means_of_influences#edit", :id => "1", type: means_of_influence_type)
        end

        it "routes #{means_of_influence_type} to #create" do
          expect(:post => "/#{means_of_influence_type.pluralize.underscore.downcase}").to route_to("means_of_influences#create", type: means_of_influence_type)
        end

        it "routes #{means_of_influence_type} to #update via PUT" do
          expect(:put => "/#{means_of_influence_type.pluralize.underscore.downcase}/1").to route_to("means_of_influences#update", :id => "1", type: means_of_influence_type)
        end

        it "routes #{means_of_influence_type} to #update via PATCH" do
          expect(:patch => "/#{means_of_influence_type.pluralize.underscore.downcase}/1").to route_to("means_of_influences#update", :id => "1", type: means_of_influence_type)
        end

        it "routes #{means_of_influence_type} to #destroy" do
          expect(:delete => "/#{means_of_influence_type.pluralize.underscore.downcase}/1").to route_to("means_of_influences#destroy", :id => "1", type: means_of_influence_type)
        end

      end
    end

  end
end
