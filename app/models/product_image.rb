class ProductImage < ActiveRecord::Base
  belongs_to :product

  has_attached_file :image, :styles => { thumb: "50x50#", list: "320", display: "640"},
                    :url => "/system/product_image/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/product_image/:id/:style/:basename.:extension"

  attr_accessible :product_id, :image
  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes

  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      "name" => read_attribute(:image_file_name),
      "size" => read_attribute(:image_file_size),
      "url" => image.url(:original),
      "thumbnail_url" => image.url(:thumb),
      "delete_url" => location_image_path(self),
      "delete_type" => "DELETE" 
    }
  end
end
