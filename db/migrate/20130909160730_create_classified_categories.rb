class CreateClassifiedCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :classified_categories do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
