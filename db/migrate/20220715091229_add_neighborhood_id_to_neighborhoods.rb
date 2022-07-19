class AddNeighborhoodIdToNeighborhoods < ActiveRecord::Migration
  def change
    add_column :neighborhoods, :neighborhood_id, :integer
  end
end
