class AddFieldsToMediaAttachments < ActiveRecord::Migration[7.0]
  def change
    add_column :media_attachments, :media_source_id, :string
    add_column :media_attachments, :media_source, :string
  end
end
