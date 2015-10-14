class OperatingHour < ActiveRecord::Base
  belongs_to :location

  attr_accessible :starts_at, :ends_at, :closed, :day

  before_validation do
    self.starts_at = self.ends_at = nil if starts_at == ends_at
  end

  def open?
    !closed?
  end
  alias_method :opened?, :open?

  def self.days
    { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }
  end

  def day
    self.class.days.key read_attribute(:day)
  end

  def day=(day)
    day = day.to_i if (day.is_a?(String) && self.class.days.values.include?(day.to_i))
    day = self.class.days[day.to_sym] unless day.is_a? Integer
    super day
  end

  self.days.each do |day|
    scope day[0], -> { where day: day[1] }

    define_method "#{day[0]}?" do
      read_attribute(:day) == day[1]
    end
  end
end
