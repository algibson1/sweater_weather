require "rails_helper"

RSpec.describe "Forecast Endpoint", :vcr do
  it "returns the current, daily, and hourly forecast weather for a given city" do
    get "/api/v0/forecast", params: {location: "cincinatti,oh"}

    expect(response).to be_successful
    expect(response.status).to eq(200)

    forecast = JSON.parse(response.body, symbolize_names: true)

    expect(forecast.keys).to eq([:data])
    expect(forecast[:data]).to be_a(Hash)

    expect(forecast[:data].keys).to match_array([:id, :type, :attributes])
    expect(forecast[:data][:id]).to eq(nil)
    expect(forecast[:data][:type]).to eq("forecast")

    expect(forecast[:data][:attributes].keys).to match_array([:current_weather, :daily_weather, :hourly_weather])

    expect(forecast[:data][:attributes][:current_weather].keys).to match_array([:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition, :icon])
    expect(forecast[:data][:attributes][:current_weather][:last_updated]).to be_a(String)
    expect(forecast[:data][:attributes][:current_weather][:last_updated]).to match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/)

    expect(forecast[:data][:attributes][:current_weather][:temperature]).to be_a(Float)

    expect(forecast[:data][:attributes][:current_weather][:feels_like]).to be_a(Float)
    
    expect(forecast[:data][:attributes][:current_weather][:humidity]).to be_a(Float).or be_an(Integer)
    
    expect(forecast[:data][:attributes][:current_weather][:uvi]).to be_a(Float).or be_an(Integer)
    
    expect(forecast[:data][:attributes][:current_weather][:visibility]).to be_a(Float)
    
    expect(forecast[:data][:attributes][:current_weather][:condition]).to be_a(String)
    
    expect(forecast[:data][:attributes][:current_weather][:icon]).to be_a(String)
    expect(forecast[:data][:attributes][:current_weather][:icon]).to end_with(".png")
        
    expect(forecast[:data][:attributes][:daily_weather]).to be_an(Array)
    
    expect(forecast[:data][:attributes][:daily_weather].count).to eq(5)

    forecast[:data][:attributes][:daily_weather].each do |day|
      expect(day.keys).to match_array([:date, :sunrise, :sunset, :max_temp, :min_temp, :condition, :icon])
      expect(day[:date]).to be_a(String)
      expect(day[:date]).to match(/\d{4}-\d{2}-\d{2}/)

      expect(day[:sunrise]).to be_a(String)
      expect(day[:sunrise]).to match(/\d{2}:\d{2} [AP]M/)

      expect(day[:sunrise]).to be_a(String)
      expect(day[:sunrise]).to match(/\d{2}:\d{2} [AP]M/)

      expect(day[:max_temp]).to be_a(Float)

      expect(day[:min_temp]).to be_a(Float)

      expect(day[:condition]).to be_a(String)

      expect(day[:icon]).to be_a(String)
      expect(day[:icon]).to end_with(".png")
    end
            
    expect(forecast[:data][:attributes][:hourly_weather]).to be_an(Array)
    
    expect(forecast[:data][:attributes][:hourly_weather].count).to eq(24)
    
    forecast[:data][:attributes][:hourly_weather].each do |hour|
      expect(hour.keys).to match_array([:time, :temperature, :conditions, :icon])
      expect(hour[:time]).to be_a(String)
      expect(hour[:time]).to match(/^\d{2}:\d{2}$/)

      expect(hour[:temperature]).to be_a(Float)

      expect(hour[:conditions]).to be_a(String)

      expect(hour[:icon]).to be_a(String)
      expect(hour[:icon]).to end_with(".png")
    end
  end
end