class AddAttachmentImageToNewsArticles < ActiveRecord::Migration
  def self.up
    change_table :news_articles do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :news_articles, :image
  end
end
