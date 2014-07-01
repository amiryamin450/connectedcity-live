class RenameVerticalMarketCategoryLocationTable < ActiveRecord::Migration
  def up
    rename_table :vertical_market_categories_locations, :locations_vertical_market_categories
  end

  def down
    rename_table :locations_vertical_market_categories, :vertical_market_categories_locations
  end
end
