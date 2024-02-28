class AddSlugToCountries < ActiveRecord::Migration[7.0]
  def change
    add_column :countries, :slug, :string
    add_index :countries, :slug
  end
end
