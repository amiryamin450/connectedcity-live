class CreateBusinesses < ActiveRecord::Migration[7.0]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :address
      t.string :address_1
      t.integer :city_id
      t.integer :state_or_province_id
      t.string :postal_code
      t.integer :country_id
      t.string :phone
      t.string :alt_phone
      t.string :fax
      t.string :email
      t.string :website
      t.string :contact_name

      t.timestamps
    end
  end
end
