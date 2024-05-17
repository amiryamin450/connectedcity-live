class AddImageToStatusUpdate < ActiveRecord::Migration[7.0]
  def change
    change_table :status_updates do |t|
      t.has_attached_file :image
    end
  end
end
