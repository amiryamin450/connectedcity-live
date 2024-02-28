class AddAttachmentCoverPhotoToNewHomeCommunities < ActiveRecord::Migration[7.0]
  def self.up
    change_table :new_home_communities do |t|
      t.attachment :cover_photo
    end
  end

  def self.down
    drop_attached_file :new_home_communities, :cover_photo
  end
end
