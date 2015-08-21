class SetDefaultForClaimPendingFlagForLocations < ActiveRecord::Migration
  def up
    change_column :locations, :claim_pending, :integer, :null => false, :default => 0
  end
end
