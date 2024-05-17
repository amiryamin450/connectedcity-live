class CreateConversations < ActiveRecord::Migration[7.0]
  def up
    create_table :conversations do |t|
      t.integer :recipient_id
      t.integer :sender_id

      t.timestamps
    end

    add_index :conversations, [:recipient_id, :sender_id], unique: true
  end

  def down
    drop_table :conversations
  end
end
