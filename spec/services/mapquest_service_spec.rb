require "rails_helper"

RSpec.describe MapquestService, :vcr do
  it "connects to mapquest api" do
    service = MapquestService.new

    expect(service.conn).to be_a(Faraday::Connection)
  end

  it "returns location info for a city" do
    service = MapquestService.new

    response = service.location_data("cincinatti,oh")

    data = JSON.parse(response.body, symbolize_names: true)
    require 'pry'; binding.pry
    coordinates = data[:results][0][:locations][0][:displayLatLng]
    expect(coordinates).to have_key(:lat)
    expect(coordinates[:lat]).to be_a(Float)
    expect(coordinates).to have_key(:lon)
    expect(coordinates[:lon]).to be_a(Float)
  end
end