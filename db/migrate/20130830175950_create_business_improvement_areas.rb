class CreateBusinessImprovementAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :business_improvement_areas do |t|
      t.integer :district_id
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
