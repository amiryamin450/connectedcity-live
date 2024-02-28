class CreateRentalProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :rental_properties do |t|
      t.string :name
      t.string :address_1
      t.string :address_2
      t.string :postal_code
      t.string :phone
      t.string :fax
      t.string :email
      t.string :website_url
      t.integer :neighborhood_id
      t.text :neighborhood_description
      t.integer :province_id
      t.integer :city_id
      t.string :tag_line
      t.text :description
      t.text :neighborhood_highlights
      t.text :property_highlights
      t.string :facebook_url
      t.boolean :active
      t.float :latitude
      t.float :longitude
      t.string :pov
      t.string :slug
      t.string :phone_count
      t.text :property_features
      t.text :garage_types
      t.text :included_utilities
      t.text :pet_restrictions
      t.text :restrictions

      t.timestamps
    end
  end
end
