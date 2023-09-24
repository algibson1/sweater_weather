class WeatherFacade 
  def get_forecast(location)
    response = service.forecast(coordinates(location))
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def coordinates(location)
    MapquestFacade.new.coordinates(location)
  end

  private 

  def service
    @service = WeatherService.new
  end
end