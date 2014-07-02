class AddGeoToNewHomeCommunities < ActiveRecord::Migration
  def change
    add_column :new_home_communities, :latitude, :float
    add_column :new_home_communities, :longitude, :float
  end
end
