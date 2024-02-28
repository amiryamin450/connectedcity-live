class RenameStateOrProvinceIdRegions < ActiveRecord::Migration[7.0]
  def up
    rename_column :regions, :state_or_province_id, :province_id
    rename_column :cities, :state_or_province_id, :province_id
    rename_column :businesses, :state_or_province_id, :province_id
    rename_column :locations, :state_or_province_id, :province_id
  end

  def down
  end
end
