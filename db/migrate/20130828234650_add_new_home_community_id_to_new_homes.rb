class AddNewHomeCommunityIdToNewHomes < ActiveRecord::Migration
  def change
    add_column :new_homes, :new_home_community_id, :integer
  end
end
