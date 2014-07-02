class RenameColumnsOnMediaAttachments < ActiveRecord::Migration
  def up
    rename_column :media_attachments, :attatchable_id, :attachable_id
    rename_column :media_attachments, :attatchable_type, :attachable_type
    rename_column :media_attachments, :attatchment, :attachment
    rename_column :media_attachments, :attatchment_html, :attachment_html
  end

  def down
  end
end
