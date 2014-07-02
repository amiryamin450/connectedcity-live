class CreateNewHomes < ActiveRecord::Migration
  def change
    create_table :new_homes do |t|
      t.integer :location_id
      t.string :title
      t.string :address
      t.string :address_suite
      t.string :postal_code
      t.float :latitude
      t.float :longitude
      t.string :slug
      t.integer :city_id
      t.integer :province_id
      t.integer :country_id
      t.string :detail_view_url
      t.string :virtual_tour_url
      t.text :description
      t.integer :bedrooms
      t.integer :bathrooms
      t.text :bedroom_comment
      t.text :bathroom_comment
      t.string :style
      t.integer :living_area
      t.integer :year_built
      t.decimal :association_fee
      t.string :association_fee_period
      t.integer :neighborhood_id
      t.decimal :list_price
      t.decimal :tax_amount

      t.timestamps
    end
  end
end
