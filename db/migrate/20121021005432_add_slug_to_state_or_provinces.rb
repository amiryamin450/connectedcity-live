class AddSlugToStateOrProvinces < ActiveRecord::Migration[7.0]
  def change
    add_column :state_or_provinces, :slug, :string
    add_index :state_or_provinces, :slug
  end
end
