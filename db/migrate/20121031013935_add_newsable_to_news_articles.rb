class AddNewsableToNewsArticles < ActiveRecord::Migration
  def change
    add_column :news_articles, :newsable_id, :integer
    add_column :news_articles, :newsable_type, :string
    remove_column :news_articles, :location_id
    add_index :news_articles, [:newsable_id, :newsable_type]
  end
end
