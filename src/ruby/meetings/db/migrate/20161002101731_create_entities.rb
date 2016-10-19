class CreateEntities < ActiveRecord::Migration[5.0]
  def change
    create_table :entities do |t|
      t.string :name
      t.string :wikipedia_entry
      t.string :type

      t.timestamps
    end
  end
end
