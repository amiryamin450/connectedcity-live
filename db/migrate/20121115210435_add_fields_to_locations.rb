class AddFieldsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :district_id, :integer
    add_column :locations, :yp_lid, :string
    add_column :locations, :yp_categories, :string
    add_column :locations, :yp_neighborhoods, :string
    add_index :locations, :yp_lid
  end
end
