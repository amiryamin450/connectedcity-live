class AddFirstAndLastNamesToUser < ActiveRecord::Migration
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    User.connection.execute("UPDATE users SET first_name = SUBSTRING(name, 1, LOCATE(' ',name)), last_name = SUBSTRING(name, LOCATE(' ',name))")

    remove_column :users, :name
  end

  def down
    add_column :users, :name, :string

    User.connection.execute("UPDATE users SET name = CONCAT(first_name,' ',last_name)")

    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
