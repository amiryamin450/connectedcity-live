class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :name
      t.text :description
      t.references :location
      t.string :sku

      t.timestamps
    end
    add_index :services, :location_id
  end
end
