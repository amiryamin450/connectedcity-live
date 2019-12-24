class AddColumnUrlToCarouselImages < ActiveRecord::Migration
  def change
  	add_column :carousel_images, :url, :string
  end
end
