class CityNewsCategory < ApplicationRecord
  extend FriendlyId
  has_many :city_news_articles
  
  friendly_id :name, use: [:slugged, :history]
end
