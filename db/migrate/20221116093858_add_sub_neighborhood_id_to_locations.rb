class AddSubNeighborhoodIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :sub_neighborhood_id, :integer
  end
end
