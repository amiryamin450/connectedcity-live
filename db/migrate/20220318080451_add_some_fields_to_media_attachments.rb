class AddSomeFieldsToMediaAttachments < ActiveRecord::Migration[7.0]
  def change
    add_column :media_attachments, :description, :string
  end
end
