class AddAttachmentImageToCityNewsArticles < ActiveRecord::Migration
  def self.up
    change_table :city_news_articles do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :city_news_articles, :image
  end
end
