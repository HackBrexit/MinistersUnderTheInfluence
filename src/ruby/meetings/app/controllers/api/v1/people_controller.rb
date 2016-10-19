class Api::V1::PeopleController < JSONAPI::ResourceController
  include Swagger::Blocks
  swagger_path '/people/{id}' do
    operation :get do
      key :description, 'Returns a single person if the user has access'
      key :operationId, 'findPersonById'
      key :tags, [
        'person'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of person to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        key :description, 'person response'
        schema do
          key :'$ref', :Person
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end

  swagger_path '/people' do
    operation :get do
      key :description, 'Returns a list of people if the user has access'
      key :tags, [
        'person'
      ]
      response 200 do
        key :description, 'people response'
        schema do
          key :'$ref', :Person
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end

  swagger_path '/people' do
    operation :post do
      key :description, 'Create a new person object'
      key :tags, [
        'person'
      ]
      parameter do
        key :name, :name
        key :in, :body
        key :description, 'Name of the person to add'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :wikipedia_entry
        key :in, :body
        key :description, 'The Wikipedia entry of the person to add'
        key :required, false
        key :type, :string
      end
      response 200 do
        key :description, 'person response'
        schema do
          key :'$ref', :Person
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end

  swagger_path '/people' do
    operation :patch do
      key :description, 'Update a person object'
      key :tags, [
        'person'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of person to update'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :name, :id
        key :in, :body
        key :description, 'The id of the person to update'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :name
        key :in, :body
        key :description, 'name of the person to update'
        key :required, false
        key :type, :object
      end
      parameter do
        key :name, :wikipedia_entry
        key :in, :body
        key :description, 'The Wikipedia entry of the person to update'
        key :required, false
        key :type, :string
      end
      response 200 do
        key :description, 'person response'
        schema do
          key :'$ref', :Person
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end

end
