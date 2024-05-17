class DropVerticalMarketCategoryTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :vertical_market_categories
  end

  def down
  end
end
