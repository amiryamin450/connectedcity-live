class AddSlugToCity < ActiveRecord::Migration[7.0]
  def change
    add_column :maponics_subdivisions, :slug, :string
    add_index :maponics_subdivisions, :slug, unique: true
  end
end
