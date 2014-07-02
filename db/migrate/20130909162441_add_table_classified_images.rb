class AddTableClassifiedImages < ActiveRecord::Migration
  def change
    create_table :classified_images do |t|

      t.timestamps
    end
  end
end
