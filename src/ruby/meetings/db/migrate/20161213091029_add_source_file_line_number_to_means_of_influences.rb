class AddSourceFileLineNumberToMeansOfInfluences < ActiveRecord::Migration[5.0]
  def change
    add_column :means_of_influences, :source_file_line_number, :integer
  end
end
