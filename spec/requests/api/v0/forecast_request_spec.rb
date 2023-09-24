require "rails_helper"

RSpec.describe "Forecast Endpoint" do
  it "returns the current, daily, and hourly forecast weather for a given city" do
    get "/api/v0/forecast", params: {location: "cincinatti,oh"}

    expect(response).to be_successful
    expect(response.status).to eq(200)

    forecast = JSON.parse(response.body, symbolize_names: true)

    expect(forecast).to have_key(:data)
    expect(forecast[:data]).to be_a(Hash)

    expect(forecast[:data]).to have_key(:id)
    expect(forecast[:data][:id]).to eq(nil)

    expect(forecast[:data]).to have_key(:type)
    expect(forecast[:data][:type]).to eq("forecast")

    expect(forecast[:data]).to have_key(:attributes)

    expect(forecast[:data][:attributes]).to have_key(:current_weather)

    expect(forecast[:data][:attributes][:current_weather]).to have_key(:last_updated)
    expect(forecast[:data][:attributes][:current_weather][:last_updated]).to be_a(String)
    expect(forecast[:data][:attributes][:current_weather][:last_updated]).to match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/)

    expect(forecast[:data][:attributes][:current_weather]).to have_key(:temperature)
    expect(forecast[:data][:attributes][:current_weather][:temperature]).to be_a(Float)

    expect(forecast[:data][:attributes][:current_weather]).to have_key(:feels_like)
    expect(forecast[:data][:attributes][:current_weather][:feels_like]).to be_a(Float)
    
    expect(forecast[:data][:attributes][:current_weather]).to have_key(:humidity)
    expect(forecast[:data][:attributes][:current_weather][:humidity]).to be_a(Float).or be_an(Integer)
    
    expect(forecast[:data][:attributes][:current_weather]).to have_key(:uvi)
    expect(forecast[:data][:attributes][:current_weather][:uvi]).to be_a(Float).or be_an(Integer)
    
    expect(forecast[:data][:attributes][:current_weather]).to have_key(:visibility)
    expect(forecast[:data][:attributes][:current_weather][:visibility]).to be_a(Float)
    
    expect(forecast[:data][:attributes][:current_weather]).to have_key(:condition)
    expect(forecast[:data][:attributes][:current_weather][:condition]).to be_a(String)
    
    expect(forecast[:data][:attributes][:current_weather]).to have_key(:icon)
    expect(forecast[:data][:attributes][:current_weather][:icon]).to be_a(String)
    expect(forecast[:data][:attributes][:current_weather][:icon]).to end_with(".png")
    
    expect(forecast[:data][:attributes]).to have_key(:daily_weather)
    
    expect(forecast[:data][:attributes][:daily_weather]).to be_an(Array)
    
    expect(forecast[:data][:attributes][:daily_weather].count).to eq(5)

    forecast[:data][:attributes][:daily_weather].each do |day|
      expect(day).to have_key(:date)
      expect(day[:date]).to be_a(String)
      expect(day[:date]).to match(/\d{4}-\d{2}-\d{2}/)

      expect(day).to have_key(:sunrise)
      expect(day[:sunrise]).to be_a(String)
      expect(day[:sunrise]).to match(/\d{2}:\d{2} [AP]M/)

      expect(day).to have_key(:sunset)
      expect(day[:sunrise]).to be_a(String)
      expect(day[:sunrise]).to match(/\d{2}:\d{2} [AP]M/)

      expect(day).to have_key(:max_temp)
      expect(day[:max_temp]).to be_a(Float)

      expect(day).to have_key(:min_temp)
      expect(day[:min_temp]).to be_a(Float)

      expect(day).to have_key(:condition)
      expect(day[:condition]).to be_a(String)

      expect(day).to have_key(:icon)
      expect(day[:icon]).to be_a(String)
      expect(day[:icon]).to end_with(".png")
    end
    
    expect(forecast[:data][:attributes]).to have_key(:hourly_weather)
        
    expect(forecast[:data][:attributes][:hourly_weather]).to be_an(Array)
    
    expect(forecast[:data][:attributes][:hourly_weather].count).to eq(24)
    
    forecast[:data][:attributes][:hourly_weather].each do |hour|
      expect(hour).to have_key(:time)
      expect(hour[:time]).to be_a(String)
      expect(hour[:time]).to match(/\d{2}:\d{2}/)

      expect(hour).to have_key(:temperature)
      expect(hour[:temperature]).to be_a(Float)

      expect(hour).to have_key(:conditions)
      expect(hour[:conditions]).to be_a(String)

      expect(hour).to have_key(:icon)
      expect(hour[:icon]).to be_a(String)
      expect(hour[:icon]).to end_with(".png")
    end
    #expect what it should NOT have anywhere in it

  end
end