class AddAncestryDepthToVerticalMarkets < ActiveRecord::Migration
  def change
    add_column :vertical_markets, :ancestry_depth, :integer, :default => 0
  end
end
