class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  has_attached_file :image, styles: {:thumb => "50x50#"}
end
