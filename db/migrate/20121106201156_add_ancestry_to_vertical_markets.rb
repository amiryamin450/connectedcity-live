class AddAncestryToVerticalMarkets < ActiveRecord::Migration[7.0]
  def change
    add_column :vertical_markets, :ancestry, :string
    add_index :vertical_markets, :ancestry
  end
end
