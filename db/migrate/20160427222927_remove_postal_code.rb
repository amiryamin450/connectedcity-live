class RemovePostalCode < ActiveRecord::Migration
  def up
  	remove_column :users, :postal_code
  end

  def down
  	add_column :users, :postal_code, :string, :length => 7
  end
end
