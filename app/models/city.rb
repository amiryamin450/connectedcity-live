class City < ActiveRecord::Base



  belongs_to :province
  belongs_to :region
  belongs_to :sub_region

  has_many :locations
  has_many :districts

  has_many :status_updates, through: :locations, uniq: true
  has_many :news_articles, through: :locations, uniq: true

  default_scope includes(:province).where('provinces.country_code' => 'CA').order('cities.name')

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_attached_file :home_page_image, styles: {thumb: "100x100>"},
                    default_url: '/assets/home_page_image/:style/default.jpg'

  attr_accessible :community_id, :description, :name, :province_id, :slug, :province, 
                  :region, :region_code, :region_id, :sub_region, :sub_region_id,
                  :home_page_image
                  
  validates_presence_of :name, :province_id

end
