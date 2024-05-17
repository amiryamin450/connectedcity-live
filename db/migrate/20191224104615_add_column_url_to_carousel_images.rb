class AddColumnUrlToCarouselImages < ActiveRecord::Migration[7.0]
  def change
  	add_column :carousel_images, :url, :string
  end
end
