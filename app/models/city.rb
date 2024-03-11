class City < ApplicationRecord
  include FriendlyId

  self.table_name = "maponics_subdivisions"

  has_many :districts
  has_many :neighborhoods, through: :districts
  has_many :sub_neighborhoods, through: :neighborhoods
  has_many :locations
  has_many :status_updates
  has_many :news_articles, -> { distinct }, through: :locations
  has_many :events, -> { distinct }, through: :locations
  has_many :coupons, -> { distinct }, through: :locations
  has_many :services, -> { distinct }, through: :locations
  has_many :products, -> { distinct }, through: :locations
  has_many :media_attachments, -> { distinct }, through: :locations
  has_many :blog_entries, -> { distinct }, through: :locations
  has_many :business_improvement_areas, through: :districts
  has_many :city_news_articles
  has_many :carousel_images, as: :carouselable

  belongs_to :maponics_division, class_name: "MaponicsDivision", foreign_key: "cduid"
  belongs_to :province, foreign_key: "pruid"
  belongs_to :municipality

  default_scope { where(is_active: true).order(:csdname) }

  friendly_id :csdname, use: [:slugged]

  has_attached_file :home_page_image, styles: { thumb: "100x100>" },
                      default_url: '/assets/home_page_image/default.jpg'

  def self.without_geom_column
    column_names - ["geom"]
  end

  def name
    csdname
  end

  def label
    "#{csdname} - #{csdtype}"
  end

  def title
    csdname
  end

  def wkt
    MaponicsSubdivision.select(%q{AsText(geom) as geom}).where(:id => id).map(&:geom).first
  end

  def access_link
    "#{municipality.access_link}/#{slug}"
  end
end
