class Yarn < ApplicationRecord
  before_save do
    self.color.gsub!(/#/, '')
  end
end
