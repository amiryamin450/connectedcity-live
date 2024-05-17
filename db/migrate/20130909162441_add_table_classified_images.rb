class AddTableClassifiedImages < ActiveRecord::Migration[7.0]
  def change
    create_table :classified_images do |t|

      t.timestamps
    end
  end
end
