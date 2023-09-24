require "rails_helper"

RSpec.describe MapquestFacade, :vcr do
  it "returns latitude and longitude data for a location" do
    facade = MapquestFacade.new

    coordinates = facade.coordinates("cincinatti,oh")

    expect(coordinates).to be_a(Hash)
    expect(coordinates.count).to eq(2)
    expect(coordinates).to have_key(:lng)
    expect(coordinates[:lng]).to be_a(Float)
    expect(coordinates).to have_key(:lat)
    expect(coordinates[:lat]).to be_a(Float)
  end
end