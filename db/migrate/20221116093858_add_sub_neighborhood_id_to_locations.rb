class AddSubNeighborhoodIdToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :sub_neighborhood_id, :integer
  end
end
