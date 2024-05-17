class AddSlugToCities < ActiveRecord::Migration[7.0]
  def change
    add_column :cities, :slug, :string
    add_index :cities, :slug
  end
end
