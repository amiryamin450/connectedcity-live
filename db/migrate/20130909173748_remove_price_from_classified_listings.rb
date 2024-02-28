class RemovePriceFromClassifiedListings < ActiveRecord::Migration[7.0]
  def up
    remove_column :classified_listings, :price
    add_column :classified_listings, :price_cents, :integer
  end

  def down
    add_column :classified_listings, :price, :decimal
    remove_column :classified_listings, :price_cents
  end
end
