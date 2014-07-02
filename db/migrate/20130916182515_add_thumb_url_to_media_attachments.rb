class AddThumbUrlToMediaAttachments < ActiveRecord::Migration
  def change
    add_column :media_attatchments, :thumb_url, :string
  end
end
