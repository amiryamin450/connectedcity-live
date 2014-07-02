class AddBrokerIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :broker_id, :integer
  end
end
