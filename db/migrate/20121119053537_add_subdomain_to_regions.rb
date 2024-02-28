class AddSubdomainToRegions < ActiveRecord::Migration[7.0]
  def change
    add_column :regions, :subdomain, :string
  end
end
