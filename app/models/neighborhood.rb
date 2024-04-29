class Neighborhood < ApplicationRecord
  extend FriendlyId

  self.primary_key = 'nid'

  belongs_to :district
  belongs_to :city, foreign_key: "placecode"
  has_many :locations
  has_many :city_news_articles

  belongs_to :neighborhood, :class_name => 'Neighborhood'
  has_many :sub_neighborhoods, :class_name => 'Neighborhood', :foreign_key => 'neighborhood_id'

  default_scope { order(:neighborhd) }

  friendly_id :neighborhd, use: [:slugged]

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
