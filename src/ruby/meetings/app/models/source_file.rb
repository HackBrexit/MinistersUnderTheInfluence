class SourceFile < ApplicationRecord
  has_many  :means_of_influences
  has_many  :meetings,foreign_key: 'source_file_id'
  has_many  :hospitalities,foreign_key: 'source_file_id'
  has_many  :gifts,foreign_key: 'source_file_id'
  has_many  :travels,foreign_key: 'source_file_id'
  validates :location, :uri, presence: true
  validates :uri, uniqueness: true
end
