class Variant < ApplicationRecord
  has_many :options, dependent: :destroy
  belongs_to :product
end
