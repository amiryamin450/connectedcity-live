class AddSlugToCity < ActiveRecord::Migration
  def change
    add_column :maponics_subdivisions, :slug, :string
    add_index :maponics_subdivisions, :slug, unique: true
  end
end
