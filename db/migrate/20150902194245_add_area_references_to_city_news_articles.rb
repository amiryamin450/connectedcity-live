class AddAreaReferencesToCityNewsArticles < ActiveRecord::Migration
  def change
    add_column :city_news_articles, :city_id, :integer, :after => :city_news_category_id
    add_column :city_news_articles, :district_id, :integer, :after => :city_id
    add_column :city_news_articles, :neighborhood_id, :integer, :after => :district_id
  end
end
