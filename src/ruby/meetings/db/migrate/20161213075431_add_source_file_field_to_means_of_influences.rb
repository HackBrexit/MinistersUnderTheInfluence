class AddSourceFileFieldToMeansOfInfluences < ActiveRecord::Migration[5.0]
  def change
    add_reference :means_of_influences, :source_file, foreign_key: true
  end
end
