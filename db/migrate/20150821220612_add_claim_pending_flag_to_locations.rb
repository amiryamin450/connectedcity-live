class AddClaimPendingFlagToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :claim_pending, :integer
  end
end
