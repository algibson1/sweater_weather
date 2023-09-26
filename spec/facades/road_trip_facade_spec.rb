require "rails_helper" 

RSpec.describe RoadTripFacade, :vcr do
  it "fetches directions" do
    facade = RoadTripFacade.new({origin: "cincinatti,oh", destination: "chicago,il"})

    trip = facade.get_trip_info

    expect(trip).to be_a(RoadTrip)
    # expect distance 
    # weather 
    # etc
  end
end