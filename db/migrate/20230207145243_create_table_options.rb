class CreateTableOptions < ActiveRecord::Migration
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
