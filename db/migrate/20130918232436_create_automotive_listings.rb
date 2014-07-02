class CreateAutomotiveListings < ActiveRecord::Migration
  def change
    create_table :automotive_listings do |t|
      t.string :title
      t.string :status
      t.string :vehicle_type
      t.boolean :local
      t.boolean :accident
      t.integer :price_cents
      t.integer :year
      t.string :make
      t.string :model
      t.string :trim_level
      t.string :exterior_color
      t.string :interior_color
      t.string :enigine
      t.string :drivetrain
      t.string :transmission
      t.string :body
      t.integer :mileage
      t.string :stock_number
      t.text :description
      t.text :powertrain_specs
      t.text :suspension_specs
      t.text :specs
      t.text :entertainment_features
      t.text :seats_and_trim
      t.text :convenience_features
      t.text :body_exterior
      t.text :lighting_visibility_instruments
      t.text :saftey_and_security
      t.integer :location_id

      t.timestamps
    end
  end
end
