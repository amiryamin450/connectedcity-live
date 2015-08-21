class SetProperTypeForClaimPendingForLocations < ActiveRecord::Migration
  def up
    change_column :locations, :claim_pending, :boolean, :null => false, :default => 0
  end
end