class MeansOfInfluence < ApplicationRecord
  def self.types
    %w(Meeting Hospitality Gift Travel)
  end
  validates :month,:year,:source_file_id,:source_file_line_number,presence: true
  has_many :influence_government_office_people
  has_many :influence_organisation_people
  has_many :organisations,through: :influence_organisation_people
  has_many :organisation_people,through: :influence_organisation_people,source: 'person'
  has_many :government_people,through: :influence_government_office_people,source: 'person'
  has_many :government_offices,through: :influence_government_office_people

  belongs_to :source_file

  self.types.each do |klass|
    scope klass.underscore.downcase.pluralize.to_sym,->{where(type: klass)}
  end

  default_scope -> { order(year: :asc,month: :asc) }

end
