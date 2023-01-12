class AddMunicipalityIdLocation < ActiveRecord::Migration
  def up
    add_column :locations, :municipality_id, :integer
  end

  def down
    remove_column :locations, :municipality_id
  end
end
