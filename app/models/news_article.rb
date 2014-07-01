class NewsArticle < ActiveRecord::Base
  belongs_to :newsable, polymorphic: true
  belongs_to :user

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  default_scope order('created_at DESC')

  attr_accessible :content, :location_id, :title, :user_id, :slug, :user
end
