class AddWeightToVerticalMarkets < ActiveRecord::Migration[7.0]
  def change
    add_column :vertical_markets, :weight, :integer
  end
end
