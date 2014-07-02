class AddAttachmentCoverPhotoToEmploymentListings < ActiveRecord::Migration
  def self.up
    change_table :employment_listings do |t|
      t.attachment :cover_photo
    end
  end

  def self.down
    drop_attached_file :employment_listings, :cover_photo
  end
end
