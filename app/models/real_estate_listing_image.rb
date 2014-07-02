class RealEstateListingImage < ActiveRecord::Base
  belongs_to :real_estate_listing

  has_attached_file :image, :styles => { :thumb => "75x75#", :large => "320x240#", :display => "360x270#"},
                    :url => "/assets/real_estate_listing_image/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/real_estate_listing_image/:id/:style/:basename.:extension"

  attr_accessible :real_estate_listing_id, :image
  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes

  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      "name" => read_attribute(:image_file_name),
      "size" => read_attribute(:image_file_size),
      "url" => image.url(:original),
      "thumbnail_url" => image.url(:thumb),
      "delete_url" => location_real_estate_listing_real_estate_listings_image_path(self.real_estate_listing.location, self.real_estate_listing, self),
      "delete_type" => "DELETE" 
    }
  end
end