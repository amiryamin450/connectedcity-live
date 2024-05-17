class CreateStatusUpdateCategoryTable < ActiveRecord::Migration[7.0]
  def up
    create_table :categories_status_updates do |t|
      t.integer :category_id
      t.integer :status_update_id

      t.timestamps
    end
  end

  def down
    drop_table :categories_status_updates
  end
end
