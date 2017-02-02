class Api::V1::ApidocsController < ApplicationController
  include Swagger::Blocks

  def self.get_deployment_host
    deploy_yml = 'config/deploy.yml'
    return nil unless File.exist? deploy_yml
    yaml = File.read(deploy_yml)
    deploy = YAML.load(yaml)
    section = deploy[Rails.env.to_sym]
    section ? section[:domain] : nil
  end

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Swagger Ministers Under the Influence'
      key :description, 'API for Ministers Under the Influence ' \
        'Install the Chrome Swagger extension and point it at this json'
      contact do
        key :name, 'Hack Brexit API Team'
      end
      license do
        key :name, 'MIT'
      end
    end
    tag do
      key :name, 'person'
      key :description, 'People operations'
      externalDocs do
        key :description, 'See the JSON-API documentation'
        key :url, 'http://jsonapi.org/'
      end
    end
    key :host, Api::V1::ApidocsController::get_deployment_host || 'example.com'
    key :basePath, '/api/v1'
    key :consumes, ['application/vnd.api+json']
    key :produces, ['application/vnd.api+json']
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    Api::V1::PeopleController,
    Person,
    ErrorModel,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end

  def show
  end
end
