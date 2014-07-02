class CityNewsCategory < ActiveRecord::Base
  extend FriendlyId
  has_many :city_news_articles
  
  attr_accessible :name, :slug, :heading_color

  friendly_id :name, use: [:slugged, :history]
end
