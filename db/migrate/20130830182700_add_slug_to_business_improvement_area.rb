class AddSlugToBusinessImprovementArea < ActiveRecord::Migration[7.0]
  def change
    add_column :business_improvement_areas, :slug, :string
  end
end
