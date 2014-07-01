class AddProvinceIdToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :province_id, :integer
    add_column :regions, :province_name, :string
  end
end
