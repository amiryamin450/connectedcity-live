class CreateTradeAssociations < ActiveRecord::Migration[7.0]
  def change
    create_table :trade_associations do |t|
      t.string :name
      t.text :description
      t.references :city
      t.references :province
      t.string :slug
      t.string :website_url

      t.timestamps
    end
    add_index :trade_associations, :city_id
    add_index :trade_associations, :province_id
  end
end
