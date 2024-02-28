class AddBrokerIdToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :broker_id, :integer
  end
end
