class AddLocationIdToEmploymentListings < ActiveRecord::Migration[7.0]
  def change
    add_column :employment_listings, :location_id, :integer
  end
end
