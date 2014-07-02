class AddDistrictIdToNeighborhoods < ActiveRecord::Migration
  def change
    add_column :neighborhoods, :district_id, :int
  end
end
