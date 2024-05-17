class AddEmploymentCategoryIdToEmploymentListings < ActiveRecord::Migration[7.0]
  def change
    add_column :employment_listings, :employment_category_id, :integer
  end
end
