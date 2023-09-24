require "rails_helper"

RSpec.describe WeatherService, :vcr do
  it "connects to the weather API" do
    service = WeatherService.new

    expect(service.conn).to be_a(Faraday::Connection)
  end

  it "returns full forecast: current weather, plus hourly data for next 5 days" do
    service = WeatherService.new

    response = service.forecast({lat: 39.11, lng: -84.5})

    data = JSON.parse(response.body, symbolize_names: true)

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

    expect(data).to have_key(:forecast)
    expect(data[:forecast]).to have_key(:forecastday)
    expect(data[:forecast][:forecastday]).to be_an(Array)
    expect(data[:forecast][:forecastday].count).to eq(5)
    
    data[:forecast][:forecastday].each do |day|
      expect(day).to have_key(:date)
      expect(day).to have_key(:astro)
      expect(day[:astro]).to have_key(:sunrise)
      expect(day[:astro]).to have_key(:sunset)
      expect(day).to have_key(:day)
      expect(day[:day]).to have_key(:maxtemp_f)
      expect(day[:day]).to have_key(:mintemp_f)
      expect(day[:day]).to have_key(:condition)
      expect(day[:day][:condition]).to have_key(:text)
      expect(day[:day][:condition]).to have_key(:icon)

      expect(day).to have_key(:hour)
      expect(day[:hour]).to be_an(Array)
      expect(day[:hour].count).to eq(24)

      day[:hour].each do |hour|
        expect(hour).to have_key(:time)
        expect(hour).to have_key(:temp_f)
        expect(hour).to have_key(:condition)
        expect(hour[:condition]).to have_key(:text)
        expect(hour[:condition]).to have_key(:icon)
      end
    end
  end
end