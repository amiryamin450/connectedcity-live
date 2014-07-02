class AddAttachmentImageToRealEstateListingImages < ActiveRecord::Migration
  def self.up
    change_table :real_estate_listing_images do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :real_estate_listing_images, :image
  end
end
