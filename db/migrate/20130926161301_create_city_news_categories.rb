class CreateCityNewsCategories < ActiveRecord::Migration
  def change
    create_table :city_news_categories do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
