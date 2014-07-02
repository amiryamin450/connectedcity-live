class AddHeadingColorToClassifiedCategories < ActiveRecord::Migration
  def change
    add_column :classified_categories, :heading_color, :string
  end
end
