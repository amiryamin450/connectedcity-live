class AddIsDraftToMediaAttachments < ActiveRecord::Migration
  def change
    add_column :media_attachments, :is_draft, :boolean, default: false
  end
end
