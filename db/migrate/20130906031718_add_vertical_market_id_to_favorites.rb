class AddVerticalMarketIdToFavorites < ActiveRecord::Migration
  def change
    add_column :favorites, :vertical_market_id, :integer
  end
end
