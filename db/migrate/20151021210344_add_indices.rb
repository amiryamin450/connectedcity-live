class AddIndices < ActiveRecord::Migration
  def change
    add_index :locations_vertical_market_categories, [:vertical_market_category_id, :location_id], unique: true, name: "lvmc_vertical_market_category_id_location_id"
    add_index :media_attachments, [:attachable_id, :attachable_type]
    add_index :maponics_division, :cduid, unique: true
    add_index :maponics_provinces, :pruid, unique: true
    add_index :maponics_subdivisions, :csdtype
    add_index :vertical_market_categories, :vertical_market_id

    change_column :maponics_division, :cduid, :integer
    change_column :maponics_provinces, :pruid, :integer
  end
end
