class MapquestService
  def conn
    Faraday.new("https://www.mapquestapi.com/") do |faraday|
      faraday.params[:key] = Rails.application.credentials.mapquest[:key]
    end
  end

  def location_data(location)
    conn.get("/geocoding/v1/address") do |faraday|
      faraday.params[:location] = location
    end
  end

  def get_directions(locations)
    conn.get("/directions/v2/route") do |faraday|
      faraday.params[:from] = locations[:origin]
      faraday.params[:to] = locations[:destination]
    end
  end
end