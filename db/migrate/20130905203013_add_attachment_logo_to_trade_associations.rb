class AddAttachmentLogoToTradeAssociations < ActiveRecord::Migration[7.0]
  def self.up
    change_table :trade_associations do |t|
      t.attachment :logo
    end
  end

  def self.down
    drop_attached_file :trade_associations, :logo
  end
end
