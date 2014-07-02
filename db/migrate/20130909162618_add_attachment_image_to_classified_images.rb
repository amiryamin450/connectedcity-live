class AddAttachmentImageToClassifiedImages < ActiveRecord::Migration
  def self.up
    change_table :classified_images do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :classified_images, :image
  end
end
