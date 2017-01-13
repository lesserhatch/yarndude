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

    already_fetched_dates = blanket.fetched_dates

    (start_date .. end_date).each do |date|
      # Skip this date if we already fetched it
      next if already_fetched_dates.include? date
      begin
        retries ||= 0
        blanket.fetch_date(date)
      rescue Faraday::SSLError
        sleep 5
        retry if (retries += 1) < 3
      end
    end

    if blanket.is_data_complete?
      blanket.ready = true
      blanket.save
      UserMailer.ready_email(blanket).deliver_later
    end
  end
end
