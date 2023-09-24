class WeatherService
  def conn 
    Faraday.new("http://api.weatherapi.com/v1") do |faraday|
      faraday.params[:key] = Rails.application.credentials.weather[:key]
    end
  end

  def forecast(coordinates)
    conn.get("forecast.json") do |faraday|
      faraday.params[:q] = "#{coordinates[:lat]},#{coordinates[:lng]}"
      faraday.params[:days] = 5
    end
  end
end