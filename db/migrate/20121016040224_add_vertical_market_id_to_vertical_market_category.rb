class AddVerticalMarketIdToVerticalMarketCategory < ActiveRecord::Migration
  def change
    add_column :vertical_market_categories, :vertical_market_id, :integer
  end
end
