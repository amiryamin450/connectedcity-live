class RemoveColumnsFromRegions < ActiveRecord::Migration
  def change
    remove_column :regions, :province_id
    remove_column :regions, :province_name
  end
end
