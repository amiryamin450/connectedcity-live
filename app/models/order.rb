class Order < ApplicationRecord
  belongs_to :customer, class_name: "User"
  belongs_to :seller, class_name: "Location"
  has_many :line_items, dependent: :destroy
  has_one :shipment, dependent: :destroy

  accepts_nested_attributes_for :shipment

  # validates_presence_of :address, :name, :vertical_market_category_ids, :province_id, :country_id, :city_id, :district_id, :municipality_id, unless: :is_profile
  validates :number, :payment_method, presence: true
  # validates :number, length: { maximum: 20 }
  validates :number, uniqueness: { case_sensitive: false, message: "Order number must be unique!" }

  enum status: [ :in_progress, :ready, :completed, :in_dispute ]

  validates :payment_method, inclusion: { in: %w(visa/mc paypal g_pay), message: "%{value} is not a valid payment method" }

  before_validation :set_number, on: :create

  DEFAULT_NUMBER_LENGTH = 10

  def set_number
    self.number = Order.maximum(:number).to_i + 1
  end

  def display_number
    number.to_s.rjust(DEFAULT_NUMBER_LENGTH, '0')
  end
end