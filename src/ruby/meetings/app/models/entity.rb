class Entity < ApplicationRecord
  def self.types
    %w(Person Organisation GovernmentOffice)
  end

  validates :name, presence: true

  self.types.each do |klass|
    scope klass.underscore.downcase.pluralize.to_sym,->{where(type: klass)}
  end

end
