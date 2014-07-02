class AddBusinessImprovementAreaIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :business_improvement_area_id, :integer
  end
end
