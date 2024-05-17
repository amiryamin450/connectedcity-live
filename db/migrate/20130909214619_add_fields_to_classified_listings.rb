class AddFieldsToClassifiedListings < ActiveRecord::Migration[7.0]
  def change
    add_column :classified_listings, :address, :string
    add_column :classified_listings, :address_1, :string
    add_column :classified_listings, :city_id, :integer
    add_column :classified_listings, :province_id, :integer
    add_column :classified_listings, :prostal_code, :string
    add_column :classified_listings, :neighborhood_id, :integer
    add_column :classified_listings, :active, :boolean
  end
end
