class CreateNewHomeCommunities < ActiveRecord::Migration[7.0]
  def change
    create_table :new_home_communities do |t|
      t.string :name
      t.integer :location_id
      t.integer :city_id
      t.integer :province_id
      t.integer :neighborhood_id
      t.text :description
      t.text :highlights

      t.timestamps
    end
  end
end
