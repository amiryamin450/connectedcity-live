class AddAncestryDepthToVerticalMarkets < ActiveRecord::Migration[7.0]
  def change
    add_column :vertical_markets, :ancestry_depth, :integer, :default => 0
  end
end
