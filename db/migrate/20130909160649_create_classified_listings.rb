class CreateClassifiedListings < ActiveRecord::Migration
  def change
    create_table :classified_listings do |t|
      t.string :title
      t.decimal :price
      t.integer :condition
      t.text :description

      t.timestamps
    end
  end
end
