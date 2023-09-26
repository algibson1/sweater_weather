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

  it "returns an error if location is too vague" do
    facade = MapquestFacade.new

    expect {facade.coordinates("paris,utah")}.to raise_error(ActionController::BadRequest)
  end

  it "returns an error if location is gibberish" do
    facade = MapquestFacade.new

    expect {facade.coordinates("ajshdfks;dd")}.to raise_error(ActionController::BadRequest)
  end

  it "returns an error if location is nil" do
    facade = MapquestFacade.new

    expect {facade.coordinates(nil)}.to raise_error(ActionController::BadRequest)
  end

  it "returns parsed direction info" do
    facade = MapquestFacade.new

    directions = facade.get_directions({origin: "cincinatti,oh", destination: "chicago,il"})

    expect(directions).to be_a(Hash)

    expect(directions).to have_key(:formattedTime)
    expect(directions[:formattedTime]).to match(/\d{2}:\d{2}:\d{2}/)
    expect(directions).to have_key(:boundingBox)

    expect(directions[:boundingBox].keys).to match_array([:ul, :lr])
    expect(directions[:boundingBox][:ul]).to have_key(:lat)
    expect(directions[:boundingBox][:ul]).to have_key(:lng)

    expect(directions[:boundingBox][:lr]).to have_key(:lat)
    expect(directions[:boundingBox][:lr]).to have_key(:lng)
  end
end