class AddSlugToNewHomeCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :new_home_communities, :slug, :string
  end
end
