class MapquestFacade 
  def coordinates(location)
    response = service.location_data(location)
    JSON.parse(response.body, symbolize_names: true)[:results][0][:locations][0][:displayLatLng]
  end

  def service 
    @service ||= MapquestService.new
  end
end