class AddStyleToNewHomeCommunity < ActiveRecord::Migration
  def change
    add_column :new_home_communities, :style, :string
  end
end
