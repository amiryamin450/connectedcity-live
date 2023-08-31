class AddResetCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :reset_code, :string
  end
end
