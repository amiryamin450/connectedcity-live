class AddDistrictIdToNewHomeCommunities < ActiveRecord::Migration
  def change
    add_column :new_home_communities, :district_id, :integer
  end
end
