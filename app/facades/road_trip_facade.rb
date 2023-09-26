class RoadTripFacade 
  def initialize(locations)
    @locations = locations
  end

  def get_trip_info 
    directions = maps.get_directions(@locations)
    return RoadTrip.new(@locations) if directions[:routeError]
    forecast = weather.get_forecast(nil, directions[:boundingBox][:lr], 10)
    RoadTrip.new(directions, forecast)
  end

  def maps 
    @mapquest ||= MapquestFacade.new 
  end

  def weather 
    @weather ||= WeatherFacade.new
  end
end