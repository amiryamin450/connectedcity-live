class AddGeoToNewHomeCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :new_home_communities, :latitude, :float
    add_column :new_home_communities, :longitude, :float
  end
end
