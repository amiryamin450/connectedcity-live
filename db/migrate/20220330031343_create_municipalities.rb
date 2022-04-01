class CreateMunicipalities < ActiveRecord::Migration
  def change
    create_table :municipalities do |t|
      t.string :name
      t.string :slug
      t.string :municipality_code
      t.integer :region_id

      t.timestamps
    end
  end
end
