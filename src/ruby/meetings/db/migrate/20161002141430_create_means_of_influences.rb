class CreateMeansOfInfluences < ActiveRecord::Migration[5.0]
  def change
    create_table :means_of_influences do |t|
      t.string :type
      t.integer :day
      t.integer :month
      t.integer :year
      t.string :purpose
      t.string :type_of_hospitality
      t.string :gift
      t.integer :value

      t.timestamps
    end
  end
end
