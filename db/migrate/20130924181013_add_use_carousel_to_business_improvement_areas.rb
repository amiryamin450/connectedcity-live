class AddUseCarouselToBusinessImprovementAreas < ActiveRecord::Migration[7.0]
  def change
    add_column :business_improvement_areas, :use_carousel, :boolean, default: false
  end
end
