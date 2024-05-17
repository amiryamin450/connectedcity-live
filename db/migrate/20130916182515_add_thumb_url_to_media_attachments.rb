class AddThumbUrlToMediaAttachments < ActiveRecord::Migration[7.0]
  def change
    add_column :media_attatchments, :thumb_url, :string
  end
end
