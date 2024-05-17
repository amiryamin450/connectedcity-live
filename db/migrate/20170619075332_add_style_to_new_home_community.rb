class AddStyleToNewHomeCommunity < ActiveRecord::Migration[7.0]
  def change
    add_column :new_home_communities, :style, :string
  end
end
