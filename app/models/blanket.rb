class Blanket < ApplicationRecord
  has_many :days
  validates :email, :latitude, :longitude, :start_date, :end_date, presence: true
  validate :end_date_cannot_be_in_the_future
  validate :start_date_is_before_end_date
  validate :dates_cannot_span_more_than_one_year
  before_create :generate_slug

  def is_data_complete?
    # Force a data load and check if it is
    # empty before trying to check for all
    # of the dates
    days = self.days.reload
    return false if days.empty?

    expected_dates = Set.new (self.start_date .. self.end_date )
    received_dates = days.inject(Set.new []) { |dates, day| dates << day.date }
    (expected_dates == received_dates)
  end

  private

  def end_date_cannot_be_in_the_future
    if self.end_date > Date.today
      errors.add(:end_date, "can't be in the future")
    end
  end

  def start_date_is_before_end_date
    if self.start_date > self.end_date
      errors.add(:start_date, "can't be before end date")
    end
  end

  def dates_cannot_span_more_than_one_year
    if self.end_date > self.start_date.next_year
      errors.add(:end_date, "can't be more than a year")
    end
  end

  def generate_slug
    self.slug = Base64.encode64(SecureRandom.uuid)[0..12]
  end

end
