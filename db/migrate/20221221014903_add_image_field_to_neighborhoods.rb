class AddImageFieldToNeighborhoods < ActiveRecord::Migration
  def change
    add_column :neighborhoods, :logo_image, :string
  end
end
