class CreateStateOrProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :state_or_provinces do |t|
      t.string :name
      t.string :abbr
      t.integer :country_id

      t.timestamps
    end
  end
end
