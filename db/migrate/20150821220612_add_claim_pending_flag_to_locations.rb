class AddClaimPendingFlagToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :claim_pending, :integer
  end
end
