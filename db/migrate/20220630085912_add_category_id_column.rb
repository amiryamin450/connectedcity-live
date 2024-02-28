class AddCategoryIdColumn < ActiveRecord::Migration[7.0]
  def up
    add_column :status_updates, :category_id, :integer
  end

  def down
    remove_column :status_updates, :category_id
  end
end
