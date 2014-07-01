class AddSubdomainToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :subdomain, :string
  end
end
