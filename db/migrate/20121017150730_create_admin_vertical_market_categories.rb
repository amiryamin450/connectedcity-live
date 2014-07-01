class CreateAdminVerticalMarketCategories < ActiveRecord::Migration
  def change
    create_table :admin_vertical_market_categories do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.integer :vertical_market_id
      t.string :default_logo

      t.timestamps
    end
  end
end
