class AddStatusableToStatusUpdates < ActiveRecord::Migration[7.0]
  def change
    add_column :status_updates, :statusable_id, :integer
    add_column :status_updates, :statusable_type, :string
    remove_column :status_updates, :location_id
    add_index :status_updates, [:statusable_type, :statusable_id]
  end
end
