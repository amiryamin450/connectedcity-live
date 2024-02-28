class AddAttachmentCoverPhotoToLocations < ActiveRecord::Migration[7.0]
  def self.up
    change_table :locations do |t|
      t.attachment :cover_photo
    end
  end

  def self.down
    drop_attached_file :locations, :cover_photo
  end
end
