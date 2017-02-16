class BlanketFetchDataJob < ApplicationJob
  queue_as :default

  def perform(blanket, number_of_days = :all)
    blanket.timezone = MyTimezoneFinder.timezone_at(blanket.longitude, blanket.latitude)
    blanket.save

    start_date = blanket.start_date

    # Decide how many days of data to fetch
    end_date = case number_of_days
    when :all
      blanket.end_date
    else
      blanket.start_date + number_of_days.days
    end

    # Make sure the calculated end date is not
    # after the user's specified end date
    end_date = blanket.end_date if end_date > blanket.end_date

    # Make sure the calculated end date is not
    # past the current date
    end_date = Date.yesterday if end_date > Date.yesterday

    already_fetched_dates = blanket.fetched_dates
    new_days = []

    (start_date .. end_date).each do |date|
      # Skip this date if we already fetched it
      next if already_fetched_dates.include? date
      day = blanket.fetch_date(date)
      new_days << day unless day.nil?
    end

    # Make sure we got some data before sending
    if !new_days.empty?
      UserMailer.ready_email(blanket).deliver_later unless free_mode?
    end
  end
end
