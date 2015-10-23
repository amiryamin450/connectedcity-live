class AddFirstAndLastNamesToUser < ActiveRecord::Migration
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    User.find_each do |user|
      user.name = user[:name]
      user.save!
    end

    remove_column :users, :name
  end

  def down
      remove_column :users, :first_name
      remove_column :users, :last_name
  end
end
