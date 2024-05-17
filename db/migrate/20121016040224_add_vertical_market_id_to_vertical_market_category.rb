class AddVerticalMarketIdToVerticalMarketCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :vertical_market_categories, :vertical_market_id, :integer
  end
end
