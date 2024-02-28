class RenameLocationsUsersToManagers < ActiveRecord::Migration[7.0]
  def change
    rename_table :locations_users, :managers
  end
end
