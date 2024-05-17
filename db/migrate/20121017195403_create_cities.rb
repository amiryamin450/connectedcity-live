class CreateCities < ActiveRecord::Migration[7.0]
  def change
    create_table :cities do |t|
      t.string :name
      t.text :description
      t.integer :community_id
      t.integer :state_or_province_id

      t.timestamps
    end
  end
end
