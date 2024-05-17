class AddAttachmentHomePageImageToCities < ActiveRecord::Migration[7.0]
  def self.up
    change_table :cities do |t|
      t.has_attached_file :home_page_image
    end
  end

  def self.down
    drop_attached_file :cities, :home_page_image
  end
end
