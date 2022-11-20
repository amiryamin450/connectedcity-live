class Province < ActiveRecord::Base
    # self.table_name = "maponics_provinces"
    # self.primary_key = "pruid"
    extend FriendlyId
    friendly_id :name, use: [:slugged, :history]

    attr_accessible :name, :abbr, :country_code, :country_name, :province_code

    has_many :regions
    belongs_to :country

    # has_many :metro_areas, class_name: "MetroAreas", foreign_key: "pruid"
    # has_many :cities, foreign_key: "pruid"

    # def name
    #   prename
    # end

    # def abbr
    #   preabbr
    # end

    # def id
    #   pruid
    # end

    # def wkt
    #   Province.select(%q{AsText(geom) as geom}).where(:pruid => pruid).map(&:geom).first
    # end
end
