class CreateCityNewsCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :city_news_categories do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
