class AutomotiveListing < ApplicationRecord

  belongs_to :location

  enum status: [:new, :used], _prefix: :true

  searchable do
    text :title, boost: 5
    text :make, boost: 3
    text :model, boost: 3
    text :vehicle_type
    text :trim_level
    text :description

    text :city do
      location.city.name if location && location.city
    end

    [:municipality_id, :district_id, :city_id, :neighborhood_id, :sub_neighborhood_id].each { |a|
      integer a do
        location.send(a).presence
      end
    }
  end

  monetize :price_cents

  has_many :main_images, -> { where(image_type: 'main') }, class_name: "AutomotiveListingImage", dependent: :destroy
  has_many :sub_images, -> { where(image_type: 'sub') }, class_name: "AutomotiveListingImage", dependent: :destroy

  accepts_nested_attributes_for :main_images, allow_destroy: true
  accepts_nested_attributes_for :sub_images, allow_destroy: true

  validates :title, presence: true, length: { in: 1..100 }
  validates :vehicle_type, length: { maximum: 150 }
  validates :status, :make, :model, :trim_level, presence: true
  validates :year, presence: true, numericality: { only_integer: true, greater_than: 1989 }
  validates :price, presence: true, numericality: true
  validates :mileage, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :exterior_color, :interior_color, :enigine, :drivetrain, :transmission, :body, :stock_number, :powertrain_specs, :suspension_specs, :specs, :entertainment_features, :seats_and_trim, :convenience_features, :body_exterior, :lighting_visibility_instruments, :saftey_and_security, length: { maximum: 100 }

  scope :available_in, ->(municipality_id = nil, city_id = nil, district_id = nil, neighborhood_id = nil, sub_neighborhood_id = nil) {
    if municipality_id.present?
      locations = Location.where(municipality_id: municipality_id)
    else
      locations = Location.where(city_id: city_id)
    end
    locations = locations.where(district_id: district_id) if district_id.present?
    locations = locations.where(neighborhood_id: neighborhood_id) if neighborhood_id.present?
    locations = locations.where(sub_neighborhood_id: sub_neighborhood_id) if sub_neighborhood_id.present?
    req = where("location_id IN (?)", locations.select(:id))
  }

  scope :make_by, ->(make) {
    where(make: make)
  }

  def self.ransackable_attributes(auth_object = nil)
    ["accident", "body", "body_exterior", "convenience_features", "created_at", "description", "drivetrain", "enigine", "entertainment_features", "exterior_color", "id", "interior_color", "lighting_visibility_instruments", "local", "location_id", "main_image_content_type", "main_image_file_name", "main_image_file_size", "main_image_updated_at", "make", "mileage", "model", "powertrain_specs", "price_cents", "saftey_and_security", "seats_and_trim", "specs", "status", "stock_number", "suspension_specs", "title", "transmission", "trim_level", "updated_at", "vehicle_type", "year"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["location"]
  end
end
