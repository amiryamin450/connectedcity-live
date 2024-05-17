class AddDistrictIdToNewHomeCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :new_home_communities, :district_id, :integer
  end
end
