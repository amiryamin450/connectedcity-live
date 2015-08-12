class StatusUpdate < ActiveRecord::Base
  belongs_to :statusable, polymorphic: true
  belongs_to :district
  belongs_to :neighborhood
  belongs_to :city 
  belongs_to :province

  # serialize :vertical_markets, Array
  # serialize :vertical_market_categories, Array 

  default_scope order('created_at DESC')

  has_attached_file :image, :styles => { :thumb => "75x75#", :large => "320x240#", :display => "360x270#"},
                    :url => "/assets/status_update/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/status_update/:id/:style/:basename.:extension"

  attr_accessible :content, :provider, :district_id, :neighborhood_id, :latitude, :longitude, :city_id, :province_id, 
                  :vertical_markets, :vertical_market_categories, :image

  validates_presence_of :content
  # validates_attachment_size :image, :less_than => 3.megabytes

  before_validation do 
    binding.pry
    self.district_id = self.statusable.district_id
    self.neighborhood_id = self.statusable.neighborhood_id
    self.latitude = self.statusable.latitude
    self.longitude = self.statusable.longitude
    self.city_id = self.statusable.city_id
    self.province_id = self.statusable.province_id
    self.vertical_markets = self.statusable.vertical_markets.first.id if self.statusable.vertical_markets
    self.vertical_market_categories = self.statusable.vertical_market_categories.first.id if self.statusable.vertical_market_categories
  end

end
