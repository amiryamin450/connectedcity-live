class AddAttachmentLogoToLocations < ActiveRecord::Migration[7.0]
  def self.up
    change_table :locations do |t|
      t.has_attached_file :logo
    end
  end

  def self.down
    drop_attached_file :locations, :logo
  end
end
