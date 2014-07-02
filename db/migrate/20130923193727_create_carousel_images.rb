class CreateCarouselImages < ActiveRecord::Migration
  def change
    create_table :carousel_images do |t|
      t.string :title
      t.string :caption
      t.belongs_to :carouselable, polymorphic: true

      t.timestamps
    end
    add_index :carousel_images, [:carouselable_id, :carouselable_type]
  end
end
