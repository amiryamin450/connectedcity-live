class AddSlugToNeighborhoods < ActiveRecord::Migration[7.0]
  def change
    add_column :neighborhoods, :slug, :string
  end
end
