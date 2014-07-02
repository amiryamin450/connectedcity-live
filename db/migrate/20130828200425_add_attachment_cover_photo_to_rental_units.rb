class AddAttachmentCoverPhotoToRentalUnits < ActiveRecord::Migration
  def self.up
    change_table :rental_units do |t|
      t.attachment :cover_photo
    end
  end

  def self.down
    drop_attached_file :rental_units, :cover_photo
  end
end
