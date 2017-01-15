class Palette < ApplicationRecord
  has_many :temperature_ranges
  has_many :yarns, through: :temperature_ranges
  accepts_nested_attributes_for :temperature_ranges, allow_destroy: true

  def find_yarn_by_temperature(temperature)
    return nil if temperature.nil?
    self.temperature_ranges.each do |temperature_range|
      return temperature_range.yarn if ( temperature_range.low_temperature <= temperature &&  temperature <= temperature_range.high_temperature)
    end
    nil
  end

end
