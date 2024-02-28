class RemoveColumnsFromRegions < ActiveRecord::Migration[7.0]
  def change
    remove_column :regions, :province_id
    remove_column :regions, :province_name
  end
end
