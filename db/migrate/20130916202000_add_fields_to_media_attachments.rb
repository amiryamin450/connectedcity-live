class AddFieldsToMediaAttachments < ActiveRecord::Migration
  def change
    add_column :media_attachments, :media_source_id, :string
    add_column :media_attachments, :media_source, :string
  end
end
