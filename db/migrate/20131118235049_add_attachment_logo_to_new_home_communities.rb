class AddAttachmentLogoToNewHomeCommunities < ActiveRecord::Migration
  def self.up
    change_table :new_home_communities do |t|
      t.attachment :logo
    end
  end

  def self.down
    drop_attached_file :new_home_communities, :logo
  end
end
