class AddSearchTermToVerticalMarketCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :vertical_market_categories, :search_term, :string
  end
end
