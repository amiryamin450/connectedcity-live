class Option < ActiveRecord::Base
  belongs_to :variant
  attr_accessible :name, :variant_id
end
