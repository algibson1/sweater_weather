class WeatherService
  def conn 
    Faraday.new("http://api.weatherapi.com/v1") do |faraday|
      faraday.params[:key] = Rails.application.credentials.weather[:key]
    end
  end

  def forecast(location)
    conn.get("forecast.json") do |faraday|
      coordinates = mapquest.coordinates(location)
      faraday.params[:q] = "#{coordinates[:lat]},#{coordinates[:lng]}"
      faraday.params[:days] = 5
    end
  end

  def mapquest
    @mapquest ||= MapquestFacade.new
  end
end