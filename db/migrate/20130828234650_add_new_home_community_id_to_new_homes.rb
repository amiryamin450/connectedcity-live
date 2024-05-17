class AddNewHomeCommunityIdToNewHomes < ActiveRecord::Migration[7.0]
  def change
    add_column :new_homes, :new_home_community_id, :integer
  end
end
