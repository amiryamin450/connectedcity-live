class Shipment < ApplicationRecord
  belongs_to :order

  # validates_presence_of :address, :name, :vertical_market_category_ids, :province_id, :country_id, :city_id, :district_id, :municipality_id, unless: :is_profile
  validates :tracking_number, :delivery_method, presence: true
  validates :tracking_number, length: { maximum: 30 }
  validates :tracking_number, uniqueness: { case_sensitive: true, message: "Tracking number of Shipment must be unique!" }

  enum status: [ :preparing, :ready, :in_progress, :shipped ]

  enum delivery_method: [ :pickup_in_store, :standard_ca, :express_courier ]

  before_validation :set_tracking_number, on: :create

  DEFAULT_TRACKING_NUMBER_LENGTH = 10

  def set_tracking_number
    self.tracking_number = SecureRandom.random_number(10**DEFAULT_TRACKING_NUMBER_LENGTH).to_s.rjust(DEFAULT_TRACKING_NUMBER_LENGTH, '0')
  end

  def display_status
    case status.to_sym
    when :preparing
      "Preparing Order"
    when :ready
      "Ready for Pick-up"
    when :in_progress
      "During shipping"
    when :shipped
      "Received"
    end
  end
end