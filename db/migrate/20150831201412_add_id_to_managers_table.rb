class AddIdToManagersTable < ActiveRecord::Migration[7.0]
  def up
    add_column :managers, :id, :primary_key, :after => :location_id
    change_column :managers, :location_id, :integer, :after => :id
  end
  def down
    remove_column :managers, :id
  end
end
