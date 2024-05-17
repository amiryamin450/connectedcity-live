class AddColumnsToRegions < ActiveRecord::Migration[7.0]
  def change
    add_column :regions, :region_code, :integer
    remove_column :regions, :province_id
  end
end
