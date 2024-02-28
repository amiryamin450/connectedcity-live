class AddWeightToClassifiedCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :classified_categories, :weight, :integer
  end
end
