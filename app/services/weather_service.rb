class WeatherService
  def conn 
    Faraday.new("http://api.weatherapi.com/v1") do |faraday|
      faraday.params[:key] = Rails.application.credentials.weather[:key]
    end
  end

  def current_weather(location)
    conn.get("current.json") do |faraday|
      coordinates = mapquest.coordinates(location)
      faraday.params[:q] = "#{coordinates[:lat]},#{coordinates[:lng]}"
    end
  end

  def mapquest
    @mapquest ||= MapquestFacade.new
  end
end