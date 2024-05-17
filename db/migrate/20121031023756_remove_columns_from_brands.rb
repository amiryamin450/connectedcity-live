class RemoveColumnsFromBrands < ActiveRecord::Migration[7.0]
  def up
    remove_column :brands, :city_id
    remove_column :brands, :province_id
    remove_column :brands, :country_id
  end

  def down
    add_column :brands, :city_id, :integer
  end
end
