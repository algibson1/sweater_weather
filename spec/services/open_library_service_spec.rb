require "rails_helper"

RSpec.describe OpenLibraryService do
  it "connects to open library API" do
    service = OpenLibraryService.new

    expect(service.conn).to be_a(Faraday::Connection)
  end

  it "searches books by location" do
    service = OpenLibraryService.new

    response = service.search({location: "denver,co"})

    results = JSON.parse(response.body, symbolize_names: true)
    
    expect(results).to have_key(:numfound)
    
  end
end