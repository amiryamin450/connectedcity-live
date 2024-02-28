class AddAttachmentImageToBlogEntries < ActiveRecord::Migration[7.0]
  def self.up
    change_table :blog_entries do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :blog_entries, :image
  end
end
