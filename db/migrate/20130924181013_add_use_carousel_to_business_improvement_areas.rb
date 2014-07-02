class AddUseCarouselToBusinessImprovementAreas < ActiveRecord::Migration
  def change
    add_column :business_improvement_areas, :use_carousel, :boolean, default: false
  end
end
