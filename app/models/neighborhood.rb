class Neighborhood < ApplicationRecord
  extend FriendlyId

  self.primary_key = 'nid'

  belongs_to :district, optional: true
  belongs_to :city, foreign_key: "placecode"
  has_many :locations_of_neighborhood, -> { where(is_profile: false) }, :class_name => "Location", foreign_key: 'neighborhood_id'
  has_many :city_news_articles

  belongs_to :neighborhood, :class_name => 'Neighborhood'
  has_many :sub_neighborhoods, :class_name => 'Neighborhood', :foreign_key => 'neighborhood_id'

  # This is for neighborhood
  has_many :coupons_of_neighborhood, -> { distinct }, through: :locations_of_neighborhood, source: :coupons
  has_many :services_of_neighborhood, -> { distinct }, through: :locations_of_neighborhood, source: :services
  has_many :products_of_neighborhood, -> { distinct }, through: :locations_of_neighborhood, source: :products
  has_many :media_attachments_of_neighborhood, -> { distinct }, through: :locations_of_neighborhood, source: :media_attachments
  has_many :blog_entries_of_neighborhood, -> { distinct }, through: :locations_of_neighborhood, source: :blog_entries
  has_many :status_updates_of_neighborhood, -> { distinct },through: :locations_of_neighborhood, source: :status_updates
  has_many :news_articles_of_neighborhood, -> { distinct }, through: :locations_of_neighborhood, source: :news_articles
  has_many :events_of_neighborhood, -> { distinct }, through: :locations_of_neighborhood, source: :events

  # This is for sub_neighborhood
  has_many :locations_of_sub_neighborhood, -> { where(is_profile: false) }, :class_name => "Location", foreign_key: 'sub_neighborhood_id'
  has_many :coupons_of_sub_neighborhood, -> { distinct }, through: :locations_of_sub_neighborhood, source: :coupons
  has_many :services_of_sub_neighborhood, -> { distinct }, through: :locations_of_sub_neighborhood, source: :services
  has_many :products_of_sub_neighborhood, -> { distinct }, through: :locations_of_sub_neighborhood, source: :products
  has_many :media_attachments_of_sub_neighborhood, -> { distinct }, through: :locations_of_sub_neighborhood, source: :media_attachments
  has_many :blog_entries_of_sub_neighborhood, -> { distinct }, through: :locations_of_sub_neighborhood, source: :blog_entries
  has_many :status_updates_of_sub_neighborhood, -> { distinct },through: :locations_of_sub_neighborhood, source: :status_updates
  has_many :news_articles_of_sub_neighborhood, -> { distinct }, through: :locations_of_sub_neighborhood, source: :news_articles
  has_many :events_of_sub_neighborhood, -> { distinct }, through: :locations_of_sub_neighborhood, source: :events

  default_scope { order(:neighborhd) }

  friendly_id :neighborhd, use: [:slugged]

  def locations
    neighborhood_id.present? ? locations_of_sub_neighborhood : locations_of_neighborhood
  end

  def coupons
    neighborhood_id.present? ? coupons_of_sub_neighborhood : coupons_of_neighborhood
  end

  def services
    neighborhood_id.present? ? services_of_sub_neighborhood : services_of_neighborhood
  end

  def products
    neighborhood_id.present? ? products_of_sub_neighborhood : products_of_neighborhood
  end

  def media_attachments
    neighborhood_id.present? ? media_attachments_of_sub_neighborhood : media_attachments_of_neighborhood
  end

  def blog_entries
    neighborhood_id.present? ? blog_entries_of_sub_neighborhood : blog_entries_of_neighborhood
  end

  def status_updates
    neighborhood_id.present? ? status_updates_of_sub_neighborhood : status_updates_of_neighborhood
  end

  def news_articles
    neighborhood_id.present? ? news_articles_of_sub_neighborhood : news_articles_of_neighborhood
  end

  def events
    neighborhood_id.present? ? events_of_sub_neighborhood : events_of_neighborhood
  end

  def self.ransackable_attributes(auth_object = nil)
    ["cbsa", "cbsacode", "cbsatype", "cenlat", "cenlon", "color", "country", "county", "countyfips", "district_id", "geom", "logo_image", "mcd", "mcdfips", "metro", "nbr_type", "ncs_code", "neighborhd", "neighborhood_id", "nid", "place", "placecode", "po_name", "release", "slug", "state", "statefips"]
  end

  def self.without_geom_column
    column_names - ["geom"]
  end

  def as_json_without_geom
    json_data = attributes.symbolize_keys
    json_data.delete(:geom)

    json_data
  end

  def name
    neighborhd
  end

  def wkt
    Neighborhood.select(%q{AsText(geom) as geom}).where(:nid => nid).map(&:geom).first
  end

  def self.calculate( lon, lat, type = 'N')
    self.where("ST_WITHIN(POINT(#{lon}, #{lat}), geom)").first
  end

  def id
    nid
  end

  def access_link
    neighborhood_id ? "/neighbourhoods/#{slug}" : "#{district.access_link}/#{slug}"
  end

end
