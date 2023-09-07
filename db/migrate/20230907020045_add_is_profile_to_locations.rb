class AddIsProfileToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :is_profile, :boolean, default: false
  end
end
