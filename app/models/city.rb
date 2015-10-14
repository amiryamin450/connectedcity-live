class City < ActiveRecord::Base
    include FriendlyId

    self.table_name = "maponics_subdivisions"

    has_many :neighborhoods, class_name: "Neighborhood", foreign_key: "placecode"
    has_many :districts
    has_many :locations
    has_many :status_updates
    has_many :news_articles, through: :locations, uniq: true
    has_many :events, through: :locations, uniq: true
    has_many :business_improvement_areas, through: :districts
    has_many :city_news_articles

    belongs_to :maponics_division, class_name: "MaponicsDivision", foreign_key: "cduid"
    belongs_to :province, foreign_key: "pruid"

    default_scope where(csdtype: 'CY').order(:csdname)

    friendly_id :csdname, use: [:slugged]
    attr_accessible :csdname, :id, :csdtype, :slug

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


    has_attached_file :home_page_image, styles: {thumb: "100x100>"},
                        default_url: '/assets/home_page_image/default.jpg'

end
