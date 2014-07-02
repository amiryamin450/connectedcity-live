class City < ActiveRecord::Base

    self.table_name = "maponics_subdivisions"
    self.primary_key = "csduid"

    has_many :neighborhoods, class_name: "Neighborhood", foreign_key: "placecode"
    has_many :districts
    has_many :locations
    has_many :status_updates
    has_many :news_articles, through: :locations, uniq: true
    has_many :events, through: :locations, uniq: true
    has_many :business_improvement_areas, through: :districts

    belongs_to :maponics_division, class_name: "MaponicsDivision", foreign_key: "cduid"
    belongs_to :province, foreign_key: "pruid"

    default_scope where(csdtype: 'CY').order(:csdname)

    attr_accessible :csdname, :csduid, :csdtype


    def name
      csdname
    end

    def id 
      csduid
    end

    def label
      "#{csdname} - #{csdtype}"
    end

    def title
      csdname
    end

    def wkt
      MaponicsSubdivision.select(%q{AsText(geom) as geom}).where(:csduid => csduid).map(&:geom).first
    end


    has_attached_file :home_page_image, styles: {thumb: "100x100>"},
                    default_url: '/assets/home_page_image/default.jpg'

end
