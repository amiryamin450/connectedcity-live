class AddNeighborhoodIdToRealEstateListings < ActiveRecord::Migration
  def change
    add_column :real_estate_listings, :neighborhood_id, :integer
  end
end
