class CreateCityNewsArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :city_news_articles do |t|
      t.text :content
      t.string :title
      t.integer :city_news_category_id

      t.timestamps
    end
  end
end
