class User < ActiveRecord::Base
  rolify

  acts_as_messageable

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

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

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
end
