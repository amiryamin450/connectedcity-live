class AddCategoryIdColumn < ActiveRecord::Migration
  def up
    add_column :status_updates, :category_id, :integer
  end

  def down
    remove_column :status_updates, :category_id, :integer
  end
end
