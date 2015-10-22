class AddNamesAndPostalCodeToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :name, :first_name

    add_column :users, :last_name, :string, null: false
    add_column :users, :postal_code, :string
  end
end
