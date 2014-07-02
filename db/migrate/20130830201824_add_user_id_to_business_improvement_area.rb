class AddUserIdToBusinessImprovementArea < ActiveRecord::Migration
  def change
    add_column :business_improvement_areas, :user_id, :integer
  end
end
