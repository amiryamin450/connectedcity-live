class AddSlugToCityNewsArticles < ActiveRecord::Migration
  def change
    add_column :city_news_articles, :slug, :string
  end
end
