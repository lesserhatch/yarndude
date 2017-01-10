class TemperatureRange < ApplicationRecord
  belongs_to :palette
  belongs_to :yarn
end
