class AddAttachmentImageToCarouselImages < ActiveRecord::Migration[7.0]
  def self.up
    change_table :carousel_images do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :carousel_images, :image
  end
end
