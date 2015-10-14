class RenameLocationsUsersToManagers < ActiveRecord::Migration
  def change
    rename_table :locations_users, :managers
  end
end
