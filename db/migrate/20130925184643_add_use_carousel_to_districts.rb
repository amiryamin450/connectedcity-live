class AddUseCarouselToDistricts < ActiveRecord::Migration[7.0]
  def change
    add_column :districts, :use_carousel, :boolean
  end
end
