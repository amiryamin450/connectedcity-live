class AddClassifiedCategoryIdToClassifiedListings < ActiveRecord::Migration
  def change
    add_column :classified_listings, :classified_category_id, :integer
  end
end
