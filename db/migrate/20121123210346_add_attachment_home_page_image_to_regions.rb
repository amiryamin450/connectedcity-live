class AddAttachmentHomePageImageToRegions < ActiveRecord::Migration
  def self.up
    change_table :regions do |t|
      t.has_attached_file :home_page_image
    end
  end

  def self.down
    drop_attached_file :regions, :home_page_image
  end
end
