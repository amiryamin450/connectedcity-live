class CreateListingTable < ActiveRecord::Migration[7.0]
  def change
    create_table :real_estate_listings do |t|
      t.string :listing_source
      t.string :email
      t.string :web_bug_url
      t.integer :listing_source_id
      t.string :provider_listing_id
      t.string :provider
      t.string :regional_mls_number
      t.boolean :regional_mls_number_visible
      t.datetime :last_update_date
      t.string :status
      t.string :title
      t.string :detail_view_url
      t.references :country
      t.references :province
      t.string :address
      t.boolean :address_visible
      t.string :address_suite
      t.string :postal_code
      t.float :latitude
      t.float :longitude
      t.references :city
      t.string :description
      t.decimal :list_price
      t.decimal :tax_amount
      t.string :property_type
      t.string :style
      t.string :lot_comment
      t.string :lot_legal
      t.decimal :rental_price
      t.string :rental_period
      t.string :rental_currency
      t.integer :bedrooms
      t.string :bedroom_comment
      t.integer :bathrooms
      t.string :bathroom_comment
      t.string :garage
      t.integer :garage_stalls
      t.string :garage_style
      t.string :garage_comment
      t.string :living_area
      t.decimal :living_area_unit
      t.integer :year_built
      t.string :year_built_comment
      t.string :broker_name
      t.datetime :list_date
      t.string :virtual_tour_url
      t.decimal :association_fee
      t.string :association_fee_period
      t.string :association_fee_currency
      t.string :neighborhood
      t.references :location
      t.string :slug

      t.timestamps
    end

    add_index :real_estate_listings, :city_id
    add_index :real_estate_listings, :province_id
    add_index :real_estate_listings, :country_id
    add_index :real_estate_listings, :slug
    

  end
end
