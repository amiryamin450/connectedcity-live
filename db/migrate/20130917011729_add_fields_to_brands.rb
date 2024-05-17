class AddFieldsToBrands < ActiveRecord::Migration[7.0]
  def change
    add_column :brands, :website_url, :string
  end
end
