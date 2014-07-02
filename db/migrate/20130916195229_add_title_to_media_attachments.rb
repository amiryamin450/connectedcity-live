class AddTitleToMediaAttachments < ActiveRecord::Migration
  def change
    rename_table :media_attatchments, :media_attachments
    add_column :media_attachments, :title, :string
  end
end
