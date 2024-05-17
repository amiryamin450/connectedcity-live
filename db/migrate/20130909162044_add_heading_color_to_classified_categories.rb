class AddHeadingColorToClassifiedCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :classified_categories, :heading_color, :string
  end
end
