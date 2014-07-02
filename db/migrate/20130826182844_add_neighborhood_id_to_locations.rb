class AddNeighborhoodIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :neighborhood_id, :int
  end
end
