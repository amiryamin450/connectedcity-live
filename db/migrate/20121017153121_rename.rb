class Rename < ActiveRecord::Migration
  def up
    rename_table :admin_vertical_market_categories, :vertical_market_categories
  end

  def down
    rename_table :vertical_market_categories, :admin_vertical_market_categories
  end
end
