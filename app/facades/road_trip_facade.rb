class RoadTripFacade 
  def initialize(locations)
    @locations = locations
  end

  def get_trip_info 
    directions = maps.get_directions(@locations)
    forecast = weather.get_forecast(nil, directions[:boundingBox][:ul])
    RoadTrip.new(directions, forecast)
  end

  def maps 
    @mapquest ||= MapquestFacade.new 
  end

  def weather 
    @weather ||= WeatherFacade.new
  end
end