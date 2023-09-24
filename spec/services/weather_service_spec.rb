require "rails_helper"

RSpec.describe WeatherService do
  it "connects to the weather API" do
    service = WeatherService.new

    expect(service.conn).to be_a(Faraday::Connection)
  end

  xit "returns current weather for a given city" do
    service = WeatherService.new

    response = service.current_weather("cincinatti,oh")

  end
end