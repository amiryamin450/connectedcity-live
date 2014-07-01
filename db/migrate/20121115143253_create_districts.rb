class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :name
      t.text :description
      t.integer :city_id
      t.string :slug

      t.timestamps
    end
  end
end
