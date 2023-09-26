require "rails_helper" 

RSpec.describe RoadTripFacade, :vcr do
  it "fetches directions" do
    facade = RoadTripFacade.new({origin: "cincinatti,oh", destination: "chicago,il"})

    trip = facade.get_trip_info

    expect(trip).to be_a(RoadTrip)
    expect(trip.start_city).to eq("Cincinnati, OH")
    expect(trip.end_city).to eq("Chicago, IL")
    expect(trip.travel_time).to be_a(String)
    expect(trip.weather_at_eta).to be_a(Hash)
    expect(trip.weather_at_eta.keys).to match_array([:datetime, :temperature, :condition])
  end

  it "returns a partial poro if no directions are available" do
    facade = RoadTripFacade.new({origin: "cincinatti,oh", destination: "paris,france"})

    bad_trip = facade.get_trip_info

    expect(bad_trip).to be_a(RoadTrip)
    expect(bad_trip.start_city).to eq("cincinatti,oh")
    expect(bad_trip.end_city).to eq("paris,france")
    expect(bad_trip.travel_time).to eq("impossible")
    expect(bad_trip.weather_at_eta).to eq({})
  end
end