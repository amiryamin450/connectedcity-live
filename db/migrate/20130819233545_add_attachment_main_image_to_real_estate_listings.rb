class AddAttachmentMainImageToRealEstateListings < ActiveRecord::Migration[7.0]
  def self.up
    change_table :real_estate_listings do |t|
      t.attachment :main_image
    end
  end

  def self.down
    drop_attached_file :real_estate_listings, :main_image
  end
end
