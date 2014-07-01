class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.references :business
      t.references :city
      t.references :country
      t.references :province

      t.timestamps
    end
    add_index :brands, :business_id
    add_index :brands, :city_id
    add_index :brands, :country_id
    add_index :brands, :province_id
  end
end
