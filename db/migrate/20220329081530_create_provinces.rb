class CreateProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :provinces do |t|
      t.string :name
      t.string :abbr
      t.string :slug
      t.string :country_code
      t.string :country_name
      t.string :province_code
      t.integer :country_id

      t.timestamps
    end
  end
end
