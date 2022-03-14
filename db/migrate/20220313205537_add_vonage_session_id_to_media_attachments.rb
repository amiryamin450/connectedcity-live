class AddVonageSessionIdToMediaAttachments < ActiveRecord::Migration
  def change
    add_column :media_attachments, :vonage_session_id, :string
  end
end
