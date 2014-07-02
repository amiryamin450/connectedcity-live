class AddAttachmentHomePageImageToTradeAssociations < ActiveRecord::Migration
  def self.up
    change_table :trade_associations do |t|
      t.attachment :home_page_image
    end
  end

  def self.down
    drop_attached_file :trade_associations, :home_page_image
  end
end
