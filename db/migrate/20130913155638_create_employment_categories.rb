class CreateEmploymentCategories < ActiveRecord::Migration
  def change
    create_table :employment_categories do |t|
      t.string :name
      t.string :slug
      t.string :heading_color

      t.timestamps
    end
  end
end
