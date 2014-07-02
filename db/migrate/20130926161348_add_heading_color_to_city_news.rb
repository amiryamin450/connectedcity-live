class AddHeadingColorToCityNews < ActiveRecord::Migration
  def change
    add_column :city_news_categories, :heading_color, :string
  end
end
