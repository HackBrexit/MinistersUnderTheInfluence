class CreateInfluenceOfficePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :influence_office_people do |t|
      t.references :means_of_influence, foreign_key: true
      t.integer :office_id
      t.integer :person_id

      t.timestamps
    end
    add_index :influence_office_people, :office_id
    add_index :influence_office_people, :person_id
  end
end
