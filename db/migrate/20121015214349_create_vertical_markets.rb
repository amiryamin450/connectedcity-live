class CreateVerticalMarkets < ActiveRecord::Migration
  def change
    create_table :vertical_markets do |t|
      t.string :name
      t.text :description
      t.string :slug

      t.timestamps
    end
  end
end
