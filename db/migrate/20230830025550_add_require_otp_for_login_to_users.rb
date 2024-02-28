class AddRequireOtpForLoginToUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :otp_required_for_login
    add_column :users, :required_otp_for_login, :boolean, default: false
  end
end
