class AddFieldsToNewHomeCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :new_home_communities, :address, :string
    add_column :new_home_communities, :postal_code, :string
  end
end
