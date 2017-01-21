class Day < ApplicationRecord
  belongs_to :blanket

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
end
