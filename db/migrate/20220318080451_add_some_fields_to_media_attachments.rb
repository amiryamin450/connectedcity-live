class AddSomeFieldsToMediaAttachments < ActiveRecord::Migration
  def change
    add_column :media_attachments, :description, :string
  end
end
