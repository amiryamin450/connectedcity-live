class CreateVerticalMarketCategories < ActiveRecord::Migration
  def change
    create_table :vertical_market_categories do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.string :default_logo

      t.timestamps
    end
  end
end
