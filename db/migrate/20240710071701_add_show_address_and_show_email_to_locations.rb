class AddShowAddressAndShowEmailToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :show_address, :boolean, default: true
    add_column :locations, :show_email, :boolean, default: true
  end
end
