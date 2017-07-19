class AutomotiveListing < ActiveRecord::Base

  belongs_to :location

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

    [:district_id, :city_id, :neighborhood_id].each { |a|
      integer a do
        location.send(a).presence
      end
    }
  end

  attr_accessible :accident, :body, :body_exterior, :convenience_features, :description, :drivetrain, :enigine,
                  :entertainment_features, :exterior_color, :interior_color, :lighting_visibility_instruments,
                  :local, :location_id, :make, :mileage, :model, :powertrain_specs, :price_cents, :saftey_and_security,
                  :seats_and_trim, :specs, :status, :stock_number, :suspension_specs, :title, :transmission, :trim_level,
                  :vehicle_type, :year, :price, :main_image

  monetize :price_cents

  has_attached_file :main_image, styles: {thumb: "75x75#", list: "320", display: "750", :hp_list => "168x95" },
                    url: "/system/automotive_listing/main_image/:id/:style/:basename.:extension",
                    path: ":rails_root/public/system/automotive_listing/main_image/:id/:style/:basename.:extension",
                    default_url: "/default_images/automotive_listing/main_image/:style/missing.jpg"

  validates :title, presence: true
  validates :make, presence: true
  validates :model, presence: true
  validates :year, presence: true,  numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true,  numericality: true
  validates :mileage, presence: true,  numericality: { only_integer: true, greater_than: 0 }

  scope :available_in, ->(city_id, district_id = nil, neighborhood_id = nil) {
    locations = Location.where(city_id: city_id)
    locations = location.where(district_id: district_id) if district_id.present?
    locations = location.where(neighborhood_id: neighborhood_id) if neighborhood_id.present?
    req = where("location_id IN (?)", locations.select("id"))
  }
end
