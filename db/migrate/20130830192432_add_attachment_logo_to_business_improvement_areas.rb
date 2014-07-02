class AddAttachmentLogoToBusinessImprovementAreas < ActiveRecord::Migration
  def self.up
    change_table :business_improvement_areas do |t|
      t.attachment :logo
    end
  end

  def self.down
    drop_attached_file :business_improvement_areas, :logo
  end
end
