class AddEmploymentCategoryIdToEmploymentListings < ActiveRecord::Migration
  def change
    add_column :employment_listings, :employment_category_id, :integer
  end
end
