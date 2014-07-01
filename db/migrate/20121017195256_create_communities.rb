class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :name
      t.text :description
      t.integer :region_id

      t.timestamps
    end
  end
end
