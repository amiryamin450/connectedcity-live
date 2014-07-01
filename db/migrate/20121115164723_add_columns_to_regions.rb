class AddColumnsToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :region_code, :integer
    remove_column :regions, :province_id
  end
end
