class AddColumnShoppingCart < ActiveRecord::Migration
  def up
    add_column :line_items, :location_id, :integer
  end

  def down
    remove_column :line_items, :location_id, :integer
  end
end
