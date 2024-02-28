class AddIsDraftToMediaAttachments < ActiveRecord::Migration[7.0]
  def change
    add_column :media_attachments, :is_draft, :boolean, default: false
  end
end
