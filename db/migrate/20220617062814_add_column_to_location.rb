class AddColumnToLocation < ActiveRecord::Migration
  def up
    add_column :locations, :hall_id, :integer
    add_column :locations, :councillor_id, :integer
    add_column :locations, :commissioner_id, :integer
  end

  def down
    remove_column :locations, :hall_id
    remove_column :locations, :councillor_id
    remove_column :locations, :commissioner_id
  end
end
