class AddBusinessImprovementAreaIdToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :business_improvement_area_id, :integer
  end
end
