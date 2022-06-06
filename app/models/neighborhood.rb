class Neighborhood < ActiveRecord::Base
  extend FriendlyId

  self.primary_key = 'nid'

  belongs_to :district
  belongs_to :city, foreign_key: "placecode"
  has_many :locations
  has_many :city_news_articles

  default_scope order(:neighborhd)

  attr_accessible :district_id, :district, :slug, :neighborhd, :geom, :id

  friendly_id :neighborhd, use: [:slugged]

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

end
