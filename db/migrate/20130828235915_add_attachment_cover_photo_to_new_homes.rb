class AddAttachmentCoverPhotoToNewHomes < ActiveRecord::Migration[7.0]
  def self.up
    change_table :new_homes do |t|
      t.attachment :cover_photo
    end
  end

  def self.down
    drop_attached_file :new_homes, :cover_photo
  end
end
