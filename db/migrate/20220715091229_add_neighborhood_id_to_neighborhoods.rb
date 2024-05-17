class AddNeighborhoodIdToNeighborhoods < ActiveRecord::Migration[7.0]
  def change
    add_column :neighborhoods, :neighborhood_id, :integer
  end
end
