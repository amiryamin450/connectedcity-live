class AddColumnCategoryIdToModal < ActiveRecord::Migration
  def up
    add_column :events, :category_id, :integer
    add_column :media_attachments, :category_id, :integer
    add_column :news_articles, :category_id, :integer
  end

  def down
    remove_column :events, :category_id
    remove_column :media_attachments, :category_id
    remove_column :news_articles, :category_id
  end
end
