class Province < ApplicationRecord
    # self.table_name = "maponics_provinces"
    # self.primary_key = "pruid"
    extend FriendlyId
    friendly_id :name, use: [:slugged, :history]

    has_many :regions
    has_many :municipalities
    belongs_to :country

    # has_many :metro_areas, class_name: "MetroAreas", foreign_key: "pruid"
    has_many :cities, foreign_key: "pruid"
end
