class WeatherService
  def conn 
    Faraday.new("http://api.weatherapi.com/v1") do |faraday|
      faraday.params[:key] = Rails.application.credentials.weather[:key]
    end
  end

  def current_weather(location)
    conn.get("/current.json") do 
  end
end