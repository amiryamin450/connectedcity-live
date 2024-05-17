class SetDefaultForClaimPendingFlagForLocations < ActiveRecord::Migration[7.0]
  def up
    change_column :locations, :claim_pending, :integer, :null => false, :default => 0
  end
end
