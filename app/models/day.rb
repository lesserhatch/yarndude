class Day < ApplicationRecord
  # Associations
  belongs_to :blanket

  # Standard validations
  validates :blanket, presence: true
  validates :low_temperature, numericality: { only_integer: true }
  validates :high_temperature, numericality: { only_integer: true }
  validates :date, presence: true

  # Custom validations
  validate :low_cannot_be_greater_than_high

  def temperature_in(degrees, units)
    return degrees if units == :farhenheit
    return ((degrees - 32) * 5.0 / 9.0).to_i
  end

  def low_temperature_in(units)
    temperature_in(self.low_temperature, units)
  end

  def high_temperature_in(units)
    temperature_in(self.high_temperature, units)
  end

  private

  def low_cannot_be_greater_than_high
    unless self.low_temperature.blank? || self.high_temperature.blank?
      if self.low_temperature > self.high_temperature
        errors.add(:low_temperature, "can't be greater than high_temperature")
      end
    end
  end
end
