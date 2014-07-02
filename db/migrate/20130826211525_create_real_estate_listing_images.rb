class CreateRealEstateListingImages < ActiveRecord::Migration
  def change
    create_table :real_estate_listing_images do |t|
      t.integer :real_estate_listing_id

      t.timestamps
    end
  end
end
