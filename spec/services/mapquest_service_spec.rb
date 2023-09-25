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
    
    coordinates = data[:results][0][:locations][0][:displayLatLng]
    expect(coordinates).to have_key(:lat)
    expect(coordinates[:lat]).to be_a(Float)
    expect(coordinates).to have_key(:lng)
    expect(coordinates[:lng]).to be_a(Float)
  end

  it "gets directions" do
    service = MapquestService.new

    response = service.get_directions({origin: "cincinatti,oh", destination: "chicago,il"})

    info = JSON.parse(response.body, symbolize_names: true)

    expect(info).to have_key(:route)
    expect(info[:route]).to have_key(:formattedTime)
    expect(info[:route][:formattedTime]).to match(/\d{2}:\d{2}:\d{2}/)
    expect(info[:route]).to have_key(:boundingBox)

    expect(info[:route][:boundingBox].keys).to match_array([:ul, :lr])
    expect(info[:route][:boundingBox][:ul]).to have_key(:lat)
    expect(info[:route][:boundingBox][:ul]).to have_key(:lng)

    expect(info[:route][:boundingBox][:lr]).to have_key(:lat)
    expect(info[:route][:boundingBox][:lr]).to have_key(:lng)
  end
end