class AddSlugToBlogEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :blog_entries, :slug, :string
  end
end
