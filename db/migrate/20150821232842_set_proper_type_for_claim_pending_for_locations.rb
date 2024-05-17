class SetProperTypeForClaimPendingForLocations < ActiveRecord::Migration[7.0]
  def up
    change_column :locations, :claim_pending, :boolean, :null => false, :default => 0
  end
end