class AddColumnsAndIndexForNeighborhoods < ActiveRecord::Migration[7.0]
  def up
    add_column :neighborhoods, :created_at, :datetime, null: true, if_not_exists: true
    add_column :neighborhoods, :updated_at, :datetime, null: true, if_not_exists: true

    Neighborhood.update_all(created_at: Time.current, updated_at: Time.current)

    change_column :neighborhoods, :created_at, :datetime, null: false
    change_column :neighborhoods, :updated_at, :datetime, null: false

    change_column_null(:neighborhoods, :nid, false)
    add_index :neighborhoods, :nid, unique: true, if_not_exists: true
  end


  def down
    # remove_column :neighborhoods, :created_at
    # remove_column :neighborhoods, :updated_at

    # remove_index :neighborhoods, :nid
  end
end
