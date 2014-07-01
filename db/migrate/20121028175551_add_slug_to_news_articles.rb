class AddSlugToNewsArticles < ActiveRecord::Migration
  def change
    add_column :news_articles, :slug, :string
  end
end
