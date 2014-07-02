class CreateCityNewsArticles < ActiveRecord::Migration
  def change
    create_table :city_news_articles do |t|
      t.text :content
      t.string :title
      t.integer :city_news_category_id

      t.timestamps
    end
  end
end
