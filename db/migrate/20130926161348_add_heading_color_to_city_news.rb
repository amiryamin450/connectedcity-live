class AddHeadingColorToCityNews < ActiveRecord::Migration[7.0]
  def change
    add_column :city_news_categories, :heading_color, :string
  end
end
