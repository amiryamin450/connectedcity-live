class ClassifiedImage < ActiveRecord::Base

  belongs_to :classified_listing

  attr_accessible :image, :classified_listing, :classified_listing_id

  has_attached_file :image, :styles => { :thumb => "75x75#", :large => "320", :display => "640"},
                    :url => "/system/classified_images/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/classified_images/:id/:style/:basename.:extension"

  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes

  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      "name" => read_attribute(:image_file_name),
      "size" => read_attribute(:image_file_size),
      "url" => image.url(:original),
      "thumbnail_url" => image.url(:thumb),
      "delete_url" => classified_image_path(self),
      "delete_type" => "DELETE" 
    }
  end

    def to_jq_upload_fake
    {
      "name" => read_attribute(:image_file_name),
      "size" => read_attribute(:image_file_size),
      "url" => image.url(:original),
      "thumbnail_url" => image.url(:thumb),
      "delete_url" => '#',
      "delete_type" => "DELETE" 
    }
  end

end