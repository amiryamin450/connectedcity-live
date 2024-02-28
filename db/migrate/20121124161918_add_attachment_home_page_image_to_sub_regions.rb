class AddAttachmentHomePageImageToSubRegions < ActiveRecord::Migration[7.0]
  def self.up
    change_table :sub_regions do |t|
      t.has_attached_file :home_page_image
    end
  end

  def self.down
    drop_attached_file :sub_regions, :home_page_image
  end
end
