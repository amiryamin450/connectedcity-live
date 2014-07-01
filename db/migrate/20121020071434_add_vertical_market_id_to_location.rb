class AddVerticalMarketIdToLocation < ActiveRecord::Migration
  def up
    add_column :locations, :vertical_market_category_id, :integer
  end

  def down
    remove_column :locations, :vertical_market_category_id
  end
end
