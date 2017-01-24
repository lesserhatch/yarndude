class DailyFetchDataJob < ApplicationJob
  queue_as :default

  def perform(*args)
    blankets = (Blanket.charged).or(Blanket.examples).ending_after_yesterday

    blankets.each do |blanket|

      start_date = blanket.start_date
      end_date = Date.yesterday if blanket.end_date > Date.yesterday

      already_fetched_dates = blanket.fetched_dates
      new_days = []

      (start_date .. end_date).each do |date|
        # Skip this date if we already fetched it
        next if already_fetched_dates.include? date
        day = blanket.fetch_date(date)
        new_days << day unless day.nil?
      end

      if !new_days.empty? and blanket.email_confirmed
        UserMailer.daily_update_email(blanket, new_days).deliver_later
      end
    end
  end
end
