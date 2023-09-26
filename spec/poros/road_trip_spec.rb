require "rails_helper"

RSpec.describe RoadTrip, :vcr do
  before(:each) do
    locations = {origin: "cincinatti,oh", destination: "chicago,il"}
    @directions = MapquestFacade.new.get_directions(locations)
    @forecast = WeatherFacade.new.get_forecast(nil, @directions[:boundingBox][:ul])
    @trip = RoadTrip.new(@directions, @forecast)
  end

  it "has an origin, destination, travel time, and weather forecast" do
    expect(@trip.start_city).to eq("Cincinnati, OH")
    expect(@trip.end_city).to eq("Chicago, IL")
    expect(@trip.travel_time).to be_a(String)
    expect(@trip.travel_time).to eq(@directions[:formattedTime])
    
    expect(@trip.weather_at_eta).to be_a(Hash)
    expect(@trip.weather_at_eta.keys).to match_array([:datetime, :temperature, :condition])
    expect(@trip.weather_at_eta[:datetime]).to be_a(String)
    expect(@trip.weather_at_eta[:temperature]).to be_a(Float)
    expect(@trip.weather_at_eta[:condition]).to be_a(String)
  end

  it "formats location info (US locations)" do
    formatted = @trip.format_location({
      adminArea1: "US",
      adminArea3: "NY",
      adminArea5: "New York"
    })

    expect(formatted).to eq("New York, NY")
  end

  it "formats location info (foreign locations)" do
    formatted = @trip.format_location({
      adminArea1: "MX",
      adminArea3: "CMX",
      adminArea5: "Ciudad de México"
    })

    expect(formatted).to eq("Ciudad de México, MX")
  end

  it "finds the right hourly forecast" do
    chosen_hour = @trip.find_forecast_hour(@forecast)

    local_hour = @forecast[:location][:localtime].to_time.hour
    travel_hours = @directions[:formattedTime].to_time.hour
    
    if local_hour + travel_hours >= 24 
      expected = @forecast[:forecast][:forecastday][1][:hour][local_hour + travel_hours - 24]
    else
      expected = @forecast[:forecast][:forecastday][0][:hour][local_hour + travel_hours]
    end

    expect(chosen_hour).to eq(expected)
  end
end