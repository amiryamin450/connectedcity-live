class AddTitleToMediaAttachments < ActiveRecord::Migration[7.0]
  def change
    rename_table :media_attatchments, :media_attachments
    add_column :media_attachments, :title, :string
  end
end
