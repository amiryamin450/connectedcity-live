class AddAttachmentHomePageImageToBrands < ActiveRecord::Migration
  def self.up
    change_table :brands do |t|
      t.attachment :home_page_image
    end
  end

  def self.down
    drop_attached_file :brands, :home_page_image
  end
end
