class Category < ApplicationRecord
  has_and_belongs_to_many :products
  has_and_belongs_to_many :status_updates
  has_and_belongs_to_many :events
  has_and_belongs_to_many :media_attachments
  has_and_belongs_to_many :news_articles

  has_many :children, class_name: 'Category', foreign_key: :parent_id
end
