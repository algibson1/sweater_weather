require "rails_helper"

RSpec.describe WeatherService, :vcr do
  it "connects to the weather API" do
    service = WeatherService.new

    expect(service.conn).to be_a(Faraday::Connection)
  end

  it "returns full forecast: current weather, plus hourly data for next 5 days" do
    service = WeatherService.new

    response = service.full_forecast({lat: 39.11, lng: -84.5})

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

  it "returns forecasted weather for a given future time and day" do
    service = WeatherService.new
    future_date = Time.now + 3.days 
    formatted_date = future_date.to_s[0..9]

    response = service.forecast_for_eta({lat: 39.11, lng: -84.5}, formatted_date, 16)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to have_key(:current)

    expect(data).to have_key(:forecast)
    expect(data[:forecast]).to have_key(:forecastday)
    expect(data[:forecast][:forecastday]).to be_an(Array)
    expect(data[:forecast][:forecastday].count).to eq(1)
    
    expect(data[:forecast][:forecastday][0][:date]).to eq(formatted_date)
    expect(data[:forecast][:forecastday][0][:hour]).to be_an(Array)
    expect(data[:forecast][:forecastday][0][:hour].count).to eq(1)
    
    expect(data[:forecast][:forecastday][0][:hour][0][:time]).to include("16:00")
  end
end