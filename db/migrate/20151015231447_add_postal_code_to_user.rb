class AddPostalCodeToUser < ActiveRecord::Migration
  def up
    add_column :users, :postal_code, :string, :length => 7
  end

  def down
    remove_column :users, :postal_code
  end
end
