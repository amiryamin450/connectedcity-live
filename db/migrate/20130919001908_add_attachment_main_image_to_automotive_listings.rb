class AddAttachmentMainImageToAutomotiveListings < ActiveRecord::Migration[7.0]
  def self.up
    change_table :automotive_listings do |t|
      t.attachment :main_image
    end
  end

  def self.down
    drop_attached_file :automotive_listings, :main_image
  end
end
