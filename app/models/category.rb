class Category < ActiveRecord::Base
  attr_accessible :name, :parent_id

  has_and_belongs_to_many :products
  has_and_belongs_to_many :status_updates

  has_many :children, class_name: 'Category', foreign_key: :parent_id
end
