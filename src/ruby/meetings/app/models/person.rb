##
# This class represents a person, who can be a government person or an outside organisation person depending on the meeting/hospitality & etc
class Person < Entity
  include Swagger::Blocks
  ##
  # has_many :influence_office_people links to the intermediate table between people and meetings/hospitality/gifts/etc
  has_many :influence_office_people,foreign_key: 'person_id'
  has_many :meetings,through: :influence_office_people
  has_many :hospitalities,through: :influence_office_people
  has_many :gifts,through: :influence_office_people
  has_many :travels,through: :influence_office_people

  swagger_schema :Person do
    key :required, [:id, :name]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :wikipedia_entry do
      key :type, :string
    end
  end

  swagger_schema :PersonInput do
    allOf do
      schema do
        key :'$ref', :Person
      end
      schema do
        key :required, [:name]
        property :id do
          key :type, :integer
          key :format, :int64
        end
      end
    end
  end
end
