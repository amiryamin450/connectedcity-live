class AddAttachmentImageToLocationImages < ActiveRecord::Migration
  def self.up
    change_table :location_images do |t|
      t.has_attached_file :image
    end
  end

  def self.down
    drop_attached_file :location_images, :image
  end
end
