class CreateRentalUnits < ActiveRecord::Migration
  def change
    create_table :rental_units do |t|
      t.integer :availability
      t.integer :bathrooms
      t.integer :bedrooms
      t.integer :property_id
      t.date :date_available
      t.text :description
      t.decimal :rent_amount
      t.integer :living_area
      t.string :unit_number
      t.text :included_appliances
      t.text :flooring_types

      t.timestamps
    end
  end
end
