class AddWeightToVerticalMarkets < ActiveRecord::Migration
  def change
    add_column :vertical_markets, :weight, :integer
  end
end
