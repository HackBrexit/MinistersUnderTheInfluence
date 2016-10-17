class AddTypeToInfluenceOfficePerson < ActiveRecord::Migration[5.0]
  def change
    add_column :influence_office_people, :type, :string
  end
end
