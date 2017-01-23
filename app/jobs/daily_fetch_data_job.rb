class DailyFetchDataJob < ApplicationJob
  queue_as :default

  def perform(*args)
    blankets = Blanket.charged.or(Blanket.examples).ending_after_yesterday

    blankets.each do |blanket|

      start_date = blanket.start_date
      end_date = Date.yesterday if blanket.end_date > Date.yesterday

      already_fetched_dates = blanket.fetched_dates

      (start_date .. end_date).each do |date|
        # Skip this date if we already fetched it
        next if already_fetched_dates.include? date
        blanket.fetch_date(date)
      end

    end
  end
end
