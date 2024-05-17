class AddNeighborhoodIdToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :neighborhood_id, :int
  end
end
