class AddSlugToRegions < ActiveRecord::Migration[7.0]
  def change
    add_column :regions, :slug, :string
    add_index :regions, :slug
  end
end
