class AddAuthenticateFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :google_secret, :string
    add_column :users, :required_otp_for_login, :boolean, default: false
  end
end
