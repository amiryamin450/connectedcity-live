class AddVerticalMarketIdToFavorites < ActiveRecord::Migration[7.0]
  def change
    add_column :favorites, :vertical_market_id, :integer
  end
end
