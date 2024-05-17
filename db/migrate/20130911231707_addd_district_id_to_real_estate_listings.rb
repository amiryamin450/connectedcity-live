class AdddDistrictIdToRealEstateListings < ActiveRecord::Migration[7.0]
  def up
    add_column :real_estate_listings, :district_id, :integer
  end

  def down
    remove_column :real_estate_listings, :district_id
  end
end
