class AddSlugToNewHomeCommunities < ActiveRecord::Migration
  def change
    add_column :new_home_communities, :slug, :string
  end
end
