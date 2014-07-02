class AddAttachmentHomePageImageToBusinessImprovementAreas < ActiveRecord::Migration
  def self.up
    change_table :business_improvement_areas do |t|
      t.attachment :home_page_image
    end
  end

  def self.down
    drop_attached_file :business_improvement_areas, :home_page_image
  end
end
