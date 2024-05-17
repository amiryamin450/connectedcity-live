class AddImageFieldToNeighborhoods < ActiveRecord::Migration[7.0]
  def change
    add_column :neighborhoods, :logo_image, :string
  end
end
