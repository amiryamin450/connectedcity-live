class AddClassifiedListingIdToClassifiedImages < ActiveRecord::Migration
  def change
    add_column :classified_images, :classified_listing_id, :integer
  end
end
