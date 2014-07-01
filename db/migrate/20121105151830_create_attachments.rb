class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
        t.integer :attachable_id
        t.string :attachable_type
        t.timestamps
    end
    add_attachment :attachments, :image
    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
