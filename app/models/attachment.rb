class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  attr_accessible :image
  has_attached_file :image, styles: {:thumb => "50x50#"}
end
