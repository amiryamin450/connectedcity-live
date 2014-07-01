class CreateVerticalMarketCategoriesLocations < ActiveRecord::Migration
  def up
    create_table :vertical_market_categories_locations, :id =>false do |t|
      t.integer :vertical_market_category_id
      t.integer :location_id
    end
  end

  def down
    drop_table :vertical_market_categories_locations
  end
end
