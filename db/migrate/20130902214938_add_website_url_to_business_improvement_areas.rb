class AddWebsiteUrlToBusinessImprovementAreas < ActiveRecord::Migration[7.0]
  def change
    add_column :business_improvement_areas, :website_url, :string
  end
end
