class DailyFetchDataJob < ApplicationJob
  queue_as :default

  def perform(*args)
    blankets = Blanket.charged.ending_after_yesterday

    blankets.each do |blanket|

      start_date = blanket.start_date
      end_date = Date.today if blanket.end_date > Date.today

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

    end
  end
end
