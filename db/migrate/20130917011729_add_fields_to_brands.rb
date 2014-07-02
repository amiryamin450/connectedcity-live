class AddFieldsToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :website_url, :string
  end
end
