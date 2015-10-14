class RemoveUserIdFromLocation < ActiveRecord::Migration
  def up
    remove_column :locations, :user_id
  end

  def down
    add_column :locations, :user_id, :int
  end
end
