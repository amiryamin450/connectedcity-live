class User < ApplicationRecord
  paginates_per 100
  rolify

  acts_as_messageable
  acts_as_google_authenticated issuer: 'ConnectedCity'

  has_one :cart, dependent: :destroy
  has_many :locations
  has_many :favorites
  has_many :classified_listings
  has_many :redemptions
  has_many :coupons, through: :redemptions
  has_many :business_improvement_areas
  has_many :managers
  has_many :locations, through: :managers

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:facebook]

  validates :first_name, presence: true, unless: ->(u) { u.persisted? && u.first_name_changed? }
  validates :last_name, presence: true, unless: ->(u) { u.persisted? && u.last_name_changed? }
  validates :phone_number, presence: true, on: :create

  rolify after_add: ->(u,_){ u.touch }, after_remove: ->(u,_){ u.touch }

  def has_role?(*args)
    Rails.cache.fetch([cache_key, 'has_role?', *args]) { super }
  end

  def has_favorite? location
    favorites.find_by_location_id location.id
  end

  def self.from_facebook(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.name
      user.skip_confirmation!
    end
  end


  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end


  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def can_manage_location?(location)
    self.locations.where(id: location.id, claim_pending: 0).exists?
  end

  def has_locations?
    self.locations.size > 0
  end

  def mailboxer_email
    ""
  end

  def name
    [self.first_name, self.last_name].reject(&:blank?).join(" ")
  end

  def name=(name)
    if name.present?
      self.first_name, self.last_name = name.split(" ", 2)
    else
      self.first_name, self.last_name = nil
    end
  end

  def build_qr_code
    self.set_google_secret
    self.google_qr_uri
  end

  def profile
    location = Location.unscoped.where(email: email, is_profile: true).first
    unless location
      slug = name.presence || email.presence
      location = Location.new
      location.slug = slug.parameterize
      location.is_profile = true
      location.content = ''
      location.name = slug
      location.email = email
      location.vertical_market_categories << VerticalMarketCategory.find_by_slug('connectedcitizen')    
      location.save 
    end
    location
  end
end
