require "rails_helper"

RSpec.describe WeatherFacade, :vcr do
  it "converts city/state location into coordinates" do
    facade = WeatherFacade.new 
    coordinates = facade.coordinates("cincinatti,oh")
    
    expect(coordinates).to be_a(Hash)
    expect(coordinates).to have_key(:lat)
    expect(coordinates).to have_key(:lng)
  end

  it "fetches forecast data from weather api" do
    facade = WeatherFacade.new

    response = facade.get_forecast("cincinatti,oh")

    expect(response).to be_a(Hash)
    expect(response).to have_key(:current)
    expect(response).to have_key(:forecast)
  end
end