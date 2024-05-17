class CreateEmploymentListings < ActiveRecord::Migration[7.0]
  def change
    create_table :employment_listings do |t|
      t.string :title
      t.string :number
      t.text :locations
      t.text :description
      t.text :advantages
      t.text :qualifications
      t.integer :number_of_positions
      t.date :application_deadline

      t.timestamps
    end
  end
end
