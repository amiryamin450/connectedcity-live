class AddWebsiteUrlToBusinessImprovementAreas < ActiveRecord::Migration
  def change
    add_column :business_improvement_areas, :website_url, :string
  end
end
