class WeatherFacade 
  def get_forecast(location, coordinates = nil)
    response = service.forecast(coordinates || get_coordinates(location))
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def get_coordinates(location)
    MapquestFacade.new.coordinates(location)
  end

  private 

  def service
    @service = WeatherService.new
  end
end