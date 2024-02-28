class CreateTableOptions < ActiveRecord::Migration[7.0]
  def up
    create_table :options do |t|
      t.integer :variant_id
      t.string :name
    end
  end

  def down
    drop_table :options
  end
end
