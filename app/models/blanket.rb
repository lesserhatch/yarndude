class Blanket < ApplicationRecord
  has_many :days, dependent: :destroy
  validates :email, :latitude, :longitude, :start_date, :end_date, presence: true
  validate :end_date_cannot_be_in_the_future
  validate :start_date_is_before_end_date
  validate :dates_cannot_span_more_than_one_year
  before_create :generate_slug

  def fetched_dates
    # Return a Set of the all the days fetched
    Set.new self.days.pluck(:date)
  end

  def fetch_date(date)
    # Validate the date we are about to fetch
    return nil unless date.between?(self.start_date, self.end_date)

    # Set the timezone to the blanket's timezone
    Time.zone = self.timezone
    forecast = ForecastIO.forecast(self.latitude,
                                   self.longitude,
                                   time: Time.zone.parse(date.to_s).to_i)

    # Record the weather information for the day
    day = self.days.new
    day.date = date
    day.high_temperature = forecast.daily.data[0].temperatureMax
    day.low_temperature  = forecast.daily.data[0].temperatureMin

    # Return the day if it saved correctly
    day.save ? day : nil
  end

  def is_data_complete?
    # Force a data load and check if it is
    # empty before trying to check for all
    # of the dates
    days = self.days.reload
    return false if days.empty?

    expected_dates = Set.new (self.start_date .. self.end_date )
    received_dates = fetched_dates
    (expected_dates == received_dates)
  end

  def paid?
    not (self.customer_id.nil? && self.charge_id.nil?)
  end

  def get_charge
    return nil if self.charge_id.nil?

    begin
      Stripe::Charge.retrieve self.charge_id
    rescue Stripe::InvalidRequestError => e
      nil
    end
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
