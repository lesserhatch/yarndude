class Blanket < ApplicationRecord
  has_many :days, dependent: :destroy
  validates :email, :latitude, :longitude, :start_date, :end_date, presence: true
  validate :start_date_is_before_end_date
  validate :dates_cannot_span_more_than_one_year
  before_create :generate_slug
  before_create :generate_email_token
  before_save :strip_name_whitespace

  def self.ending_after(date)
    where('end_date > ?', date)
  end

  def self.ending_after_yesterday
    ending_after(Date.today - 2.days)
  end

  def self.charged
    where.not(charge_id: nil)
  end

  def confirm_email(token)
    self.email_confirmed = true if (self.email_token == token)
    self.save if self.email_confirmed
    self.email_confirmed
  end

  def ends_in_future?
    self.end_date > Date.today
  end

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
    day.high_temperature = forecast.daily.data[0].temperatureMax.to_i unless forecast.daily.data[0].temperatureMax.blank?
    day.low_temperature  = forecast.daily.data[0].temperatureMin.to_i unless forecast.daily.data[0].temperatureMin.blank?

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

  def safe_name
    self.name.gsub(/[\\\/<>'"]/, '').gsub(/\s+/, ' ')
  end

  private

  def start_date_is_before_end_date
    if self.start_date > self.end_date
      errors.add(:start_date, "can't be before end date")
    end
  end

  def dates_cannot_span_more_than_one_year
    if self.end_date > self.start_date.next_year
      errors.add(:end_date, "can't be more than a year after start date")
    end
  end

  def generate_slug
    self.slug = Base64.encode64(SecureRandom.uuid)[0..15]
  end

  def generate_email_token
    self.email_token = Base64.encode64(SecureRandom.uuid)[0..15]
  end

  def strip_name_whitespace
    self.name.strip!
  end

end
