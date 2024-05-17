class AddClassifiedListingIdToClassifiedImages < ActiveRecord::Migration[7.0]
  def change
    add_column :classified_images, :classified_listing_id, :integer
  end
end
