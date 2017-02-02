class CreateSourceFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :source_files do |t|
      t.string :location
      t.string :uri

      t.timestamps
    end
  end
end
