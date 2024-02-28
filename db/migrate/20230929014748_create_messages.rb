class CreateMessages < ActiveRecord::Migration[7.0]
  def up
    create_table :messages do |t|
      t.text :body
      t.references :conversation
      t.references :sender
      t.boolean :has_seen, default: false

      t.timestamps
    end
  end

  def down
    drop_table :messages
  end
end
