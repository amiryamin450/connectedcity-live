class AddAuthenticateFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :google_secret, :string
    add_column :users, :required_otp_for_login, :boolean, default: false
  end
end
