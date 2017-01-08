class BlanketFetchDataJob < ApplicationJob
  queue_as :default

  def perform(blanket)
    @blanket.timezone = MyTimezoneFinder.timezone_at(@blanket.longitude, @blanket.latitude)
    @blanket.save

    Time.zone = blanket.timezone

    (blanket.start_date .. blanket.end_date).each do |date|
      begin
        retries ||= 0
        forecast = ForecastIO.forecast(blanket.latitude,
                                       blanket.longitude,
                                       time: Time.zone.parse(date.to_s).to_i)

        day = blanket.days.new
        day.date = date
        day.high_temperature = forecast.daily.data[0].temperatureMax
        day.low_temperature  = forecast.daily.data[0].temperatureMin
        day.save
      rescue Faraday::SSLError
        sleep 5
        retry if (retries += 1) < 3
      end
    end
  end
end
