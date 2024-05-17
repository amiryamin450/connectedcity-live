class AddBloggableToBlogEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :blog_entries, :bloggable_id, :integer
    add_column :blog_entries, :bloggable_type, :string
    remove_column :blog_entries, :location_id
    add_index :blog_entries, [:bloggable_id, :bloggable_type]
  end
end
