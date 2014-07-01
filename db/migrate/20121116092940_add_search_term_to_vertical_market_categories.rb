class AddSearchTermToVerticalMarketCategories < ActiveRecord::Migration
  def change
    add_column :vertical_market_categories, :search_term, :string
  end
end
