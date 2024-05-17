class AddVerticalMarketIdToLocation < ActiveRecord::Migration[7.0]
  def up
    add_column :locations, :vertical_market_category_id, :integer
  end

  def down
    remove_column :locations, :vertical_market_category_id
  end
end
