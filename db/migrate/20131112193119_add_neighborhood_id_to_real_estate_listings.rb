class AddNeighborhoodIdToRealEstateListings < ActiveRecord::Migration[7.0]
  def change
    add_column :real_estate_listings, :neighborhood_id, :integer
  end
end
