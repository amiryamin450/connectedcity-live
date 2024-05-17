class RemoveDefaultLogoFromVerticalMarketCategory < ActiveRecord::Migration[7.0]
  def up
    remove_column :vertical_market_categories, :default_logo
  end

  def down
    add_column :vertical_market_categories, :default_logo, :string
  end
end
