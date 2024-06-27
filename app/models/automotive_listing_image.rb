class AutomotiveListingImage < ApplicationRecord
  belongs_to :automotive_listing

  has_attached_file :image, styles: {thumb: "75x75#", list: "320", display: "750", :hp_list => "168x95" }, url: "/system/automotive_listing/image/:id/:style/:basename.:extension", path: ":rails_root/public/system/automotive_listing/image/:id/:style/:basename.:extension", default_url: "/default_images/automotive_listing/image/:style/missing.jpg"

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 20.megabytes
end
