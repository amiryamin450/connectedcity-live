class AddUseCarouselToDistricts < ActiveRecord::Migration
  def change
    add_column :districts, :use_carousel, :boolean
  end
end
