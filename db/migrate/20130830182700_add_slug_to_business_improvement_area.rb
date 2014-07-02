class AddSlugToBusinessImprovementArea < ActiveRecord::Migration
  def change
    add_column :business_improvement_areas, :slug, :string
  end
end
