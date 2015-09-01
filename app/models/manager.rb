class Manager < ActiveRecord::Base

  belongs_to :user
  belongs_to :location

  before_validation :validate_and_assign_user_from_email, if: :creating_from_email?

  validates :user, presence: true
  validates :location, presence: true
  # validates :new_manager_email, presence: true, format: { with: Devise.email_regexp }, on: :create
  validate :validate_new_manager, if: -> { new_manager_email.present? }

  attr_accessor :new_manager_email

  attr_accessible :new_manager_email

  def creating_from_email!
    @creating_from_email = true
  end

  def creating_from_email?
    !!@creating_from_email
  end

  private

  def validate_new_manager
    raise ArgumentError.new("location must be set") unless self.location

    if self.user
      if self.user.locations.exists?(location.id)
        self.errors.add(:new_manager_email, "is already a manager of this business")
      end
    else
      self.errors.add(:new_manager_email, "is not registered with ConnectedCity")
    end
  end

  def validate_and_assign_user_from_email
    if self.new_manager_email.try(:[], Devise.email_regexp)
      self.user = User.find_by_email self.new_manager_email
    else
      self.errors.add(:new_manager_email, "is invalid")
    end
  end

end
