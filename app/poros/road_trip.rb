class RoadTrip
  attr_reader :start_city,
              :end_city,
              :travel_time,
              :weather_at_eta,
              :id,
              :status

  def initialize(directions, forecast = nil)
    @start_city = directions[:origin] || format_location(directions[:locations][0])
    @end_city = directions[:destination] || format_location(directions[:locations][1])
    @travel_time = directions[:formattedTime] || "impossible"
    @weather_at_eta = format_forecast(forecast)
    @id = nil
    @status = (forecast ? 200 : 422)
  end

  def format_location(data)
    "#{data[:adminArea5]}, " +
    "#{data[:adminArea1] == "US" ? data[:adminArea3] : data[:adminArea1]}"
  end
  
  def format_forecast(forecast)
    return {} if forecast.nil?
    eta_weather = find_forecast_hour(forecast)
    {
      datetime: eta_weather[:time],
      temperature: eta_weather[:temp_f],
      condition: eta_weather[:condition][:text]
    }
  end

  def find_forecast_hour(forecast)
    local_hour = forecast[:location][:localtime].to_time.hour
    hours_from_today_midnight = local_hour + @travel_time.to_i
    travel_days = hours_from_today_midnight / 24
    remaining_hours = hours_from_today_midnight % 24
    forecast[:forecast][:forecastday][travel_days][:hour][remaining_hours]
  end
end
