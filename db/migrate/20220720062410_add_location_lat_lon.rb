class AddLocationLatLon < ActiveRecord::Migration[7.0]
  def up
    add_column :events, :latitude, :float
    add_column :events, :longitude, :float
    add_column :news_articles, :latitude, :float
    add_column :news_articles, :longitude, :float
    add_column :media_attachments, :latitude, :float
    add_column :media_attachments, :longitude, :float
  end

  def down
    add_column :events, :latitude
    add_column :events, :longitude
    add_column :news_articles, :latitude
    add_column :news_articles, :longitude
    add_column :media_attachments, :latitude
    add_column :media_attachments, :longitude
  end
end
