class AddFieldsToNewHomeCommunities < ActiveRecord::Migration
  def change
    add_column :new_home_communities, :address, :string
    add_column :new_home_communities, :postal_code, :string
  end
end
