class AddSlugToCityNewsArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :city_news_articles, :slug, :string
  end
end
