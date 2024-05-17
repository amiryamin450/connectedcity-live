class AddResetCodeToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :reset_code, :string
  end
end
