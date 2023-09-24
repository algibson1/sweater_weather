require "rails_helper"

RSpec.describe WeatherService, :vcr do
  it "connects to the weather API" do
    service = WeatherService.new

    expect(service.conn).to be_a(Faraday::Connection)
  end

  it "returns current weather for a given city" do
    service = WeatherService.new

    response = service.current_weather("cincinatti,oh")

    data = JSON.parse(response.body, symbolize_names: true)
    expect(data).to have_key(:location)
    expect(data).to have_key(:current)
    expect(data[:current]).to have_key(:last_updated)
    expect(data[:current]).to have_key(:temp_f)
    expect(data[:current]).to have_key(:feelslike_f)
    expect(data[:current]).to have_key(:humidity)
    expect(data[:current]).to have_key(:uv)
    expect(data[:current]).to have_key(:vis_miles)
    expect(data[:current]).to have_key(:condition)
    expect(data[:current][:condition]).to have_key(:text)
    expect(data[:current][:condition]).to have_key(:icon)
  end
end