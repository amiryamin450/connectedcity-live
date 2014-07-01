class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :business_id
      t.integer :country_id
      t.integer :state_or_province_id
      t.integer :city_id
      t.integer :community_id
      t.integer :region_id
      t.string :name
      t.string :address
      t.string :address_1
      t.string :postal_code
      t.string :phone
      t.boolean :show_phone
      t.string :toll_free
      t.boolean :show_toll_free
      t.string :fax
      t.boolean :show_fax
      t.string :email
      t.string :website_url
      t.string :import_hash
      t.boolean :imported
      t.string :slug
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
