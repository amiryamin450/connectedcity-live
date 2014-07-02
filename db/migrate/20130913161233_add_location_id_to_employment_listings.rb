class AddLocationIdToEmploymentListings < ActiveRecord::Migration
  def change
    add_column :employment_listings, :location_id, :integer
  end
end
