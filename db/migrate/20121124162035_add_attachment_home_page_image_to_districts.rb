class AddAttachmentHomePageImageToDistricts < ActiveRecord::Migration[7.0]
  def self.up
    change_table :districts do |t|
      t.has_attached_file :home_page_image
    end
  end

  def self.down
    drop_attached_file :districts, :home_page_image
  end
end
