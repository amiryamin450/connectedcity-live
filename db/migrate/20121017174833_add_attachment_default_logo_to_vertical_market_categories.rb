class AddAttachmentDefaultLogoToVerticalMarketCategories < ActiveRecord::Migration[7.0]
  def self.up
    change_table :vertical_market_categories do |t|
      t.has_attached_file :default_logo
    end
  end

  def self.down
    drop_attached_file :vertical_market_categories, :default_logo
  end
end
