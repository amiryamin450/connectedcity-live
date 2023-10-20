class Video < ApplicationRecord
  belongs_to :media_attachment
  accepts_nested_attributes_for :media_attachment

  has_attached_file :thumbnail, :styles => { :thumb => "320x180", :original => "480x360" },
    :url => "/system/video/thumbnail/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/video/thumbnail/:id/:style/:basename.:extension"

  def media_attachment
    MediaAttachment.unscoped { super }
  end
end
