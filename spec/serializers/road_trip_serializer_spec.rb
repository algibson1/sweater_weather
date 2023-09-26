require "rails_helper"

RSpec.describe RoadTripSerializer do
  it "returns a hash of road trip information" do
    facade = RoadTripFacade.new({origin: "cincinatti,oh", destination: "chicago,il"})

    info = RoadTripSerializer.new(facade.get_trip_info)

    expect(info).to be_a(Hash)
    expect(info).to have_key(:data)
    expect(info[:data]).to be_a(Hash)

    expect(info[:data].keys).to match_array([:id, :type, :attributes])
    expect(info[:data][:id]).to eq(nil)
    expect(info[:data][:type]).to eq("road_trip")
    expect(info[:data][:attributes]).to be_a(Hash)

    expect(info[:data][:attributes].keys).to match_array([:start_city, :end_city, :travel_time, :weather_at_eta])
    expect(info[:data][:attributes][:start_city]).to eq("Cincinatti, OH")
    expect(info[:data][:attributes][:end_city]).to eq("Chicago, IL")
    expect(info[:data][:attributes][:travel_time]).to be_a(String)
    expect(info[:data][:attributes][:weather_at_eta]).to be_a(Hash)
    
    expect(info[:data][:attributes][:weather_at_eta].keys).to match_array([:datetime, :temperature, :condition])
    expect(info[:data][:attributes][:weather_at_eta][:datetime]).to be_a(String)
    expect(info[:data][:attributes][:weather_at_eta][:temperature]).to be_a(Float)
    expect(info[:data][:attributes][:weather_at_eta][:condition]).to be_a(String)
  end
end