class AddAttachmentImageToCoupons < ActiveRecord::Migration
  def self.up
    change_table :coupons do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :coupons, :image
  end
end
