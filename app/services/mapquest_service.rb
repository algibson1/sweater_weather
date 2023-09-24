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
end