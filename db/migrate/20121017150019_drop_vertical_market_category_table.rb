class DropVerticalMarketCategoryTable < ActiveRecord::Migration
  def up
    drop_table :vertical_market_categories
  end

  def down
  end
end
