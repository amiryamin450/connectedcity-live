class AddClassifiedCategoryIdToClassifiedListings < ActiveRecord::Migration[7.0]
  def change
    add_column :classified_listings, :classified_category_id, :integer
  end
end
