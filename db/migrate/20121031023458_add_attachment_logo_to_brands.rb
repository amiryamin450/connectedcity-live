class AddAttachmentLogoToBrands < ActiveRecord::Migration[7.0]
  def self.up
    change_table :brands do |t|
      t.has_attached_file :logo
    end
  end

  def self.down
    drop_attached_file :brands, :logo
  end
end
