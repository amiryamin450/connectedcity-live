class RemoveImageTypeAutomotiveListingImages < ActiveRecord::Migration[7.0]
  def change
    remove_column :automotive_listing_images, :image_type
  end
end
