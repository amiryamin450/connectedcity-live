class CreateMediaAttatchments < ActiveRecord::Migration[7.0]
  def change
    create_table :media_attatchments do |t|
      t.text :attatchment
      t.text :attatchment_html
      t.integer :attatchable_id
      t.string :attatchable_type

      t.timestamps
    end
  end
end
