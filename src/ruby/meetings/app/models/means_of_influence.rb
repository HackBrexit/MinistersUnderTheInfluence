class MeansOfInfluence < ApplicationRecord
  def self.types
    %w(Meeting Hospitality Gift Travel)
  end
  validates :month,:year,presence: true
  has_many :influence_government_office_people
  has_many :influence_organisation_people
  has_many :organisations,through: :influence_organisation_people
  has_many :organisation_people,through: :influence_organisation_people,source: 'person'
  has_many :government_people,through: :influence_government_office_people,source: 'person'
  has_many :government_offices,through: :influence_government_office_people

  self.types.each do |klass|
    scope klass.underscore.downcase.pluralize.to_sym,->{where(type: klass)}
  end
end
