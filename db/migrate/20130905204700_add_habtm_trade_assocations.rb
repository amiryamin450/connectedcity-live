class AddHabtmTradeAssocations < ActiveRecord::Migration[7.0]
  def up
    create_table :locations_trade_associations, :id =>false do |t|
      t.integer :trade_association_id
      t.integer :location_id
    end
  end

  def down
    drop_table :locations_trade_associations
  end
end
