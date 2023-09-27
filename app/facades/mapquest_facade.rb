class MapquestFacade 
  def coordinates(location)
    response = service.location_data(location)
    locations = JSON.parse(response.body, symbolize_names: true)[:results][0][:locations]
    return locations[0][:displayLatLng] if locations.count == 1 && locations[0][:source].nil?
    raise ActionController::BadRequest, "Validation failed: Could not find location matching given information"
  end

  def get_directions(locations)
    response = service.get_directions(locations)
    JSON.parse(response.body, symbolize_names: true)[:route]
  end

  def service 
    @service ||= MapquestService.new
  end
end