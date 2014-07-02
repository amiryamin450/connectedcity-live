class AddWeightToClassifiedCategories < ActiveRecord::Migration
  def change
    add_column :classified_categories, :weight, :integer
  end
end
