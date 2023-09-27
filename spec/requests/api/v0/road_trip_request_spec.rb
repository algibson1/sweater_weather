require "rails_helper"

RSpec.describe "Road trip endpoint", :vcr do
  before(:each) do
    params = {
      "email": "whatever@example.com",
      "password": "password",
      "password_confirmation": "password"
    }

    post "/api/v0/users", params: params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    @user = User.last
  end

  it "calculates travel time and the forecast it will be after that amount of time" do

    params = {
      "origin": "Cincinatti,OH",
      "destination": "Chicago,IL",
      "api_key": @user.api_key
    }    

    post "/api/v0/road_trip", params: params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    expect(response).to be_successful
    expect(response.status).to eq(200)

    data = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(data.keys).to match_array([:id, :type, :attributes])
    expect(data[:id]).to eq(nil)
    expect(data[:type]).to eq("road_trip")
        expect(data[:attributes]).to be_a(Hash)

    expect(data[:attributes].keys).to match_array([:start_city, :end_city, :travel_time, :weather_at_eta])
    expect(data[:attributes][:start_city]).to eq("Cincinnati, OH")
    expect(data[:attributes][:end_city]).to eq("Chicago, IL")
    expect(data[:attributes][:travel_time]).to be_a(String)
    expect(data[:attributes][:travel_time]).to match(/\d{2}:\d{2}/)
    expect(data[:attributes][:weather_at_eta]).to be_a(Hash)

    expect(data[:attributes][:weather_at_eta].keys).to match_array([:datetime, :temperature, :condition])
    expect(data[:attributes][:weather_at_eta][:datetime]).to be_a(String)
    expect(data[:attributes][:weather_at_eta][:datetime]).to match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/)
    expect(data[:attributes][:weather_at_eta][:temperature]).to be_a(Float)
    expect(data[:attributes][:weather_at_eta][:condition]).to be_a(String)
  end

  it "throws an error if api key is invalid" do

    params = {
      "origin": "Cincinatti,OH",
      "destination": "Chicago,IL",
      "api_key": "bad_api_key"
    }    

    post "/api/v0/road_trip", params: params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    expect(response.status).to eq(401)

    message = JSON.parse(response.body, symbolize_names: true)

    expect(message).to eq({errors: [{detail: "Validation failed: Api key is missing or invalid"}]})
  end

  it "throws an error if api key is missing" do 
    params = {
      "origin": "Cincinatti,OH",
      "destination": "Chicago,IL"
    }    

    post "/api/v0/road_trip", params: params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    expect(response.status).to eq(401)

    message = JSON.parse(response.body, symbolize_names: true)

    expect(message).to eq({errors: [{detail: "Validation failed: Api key is missing or invalid"}]})
  end

  it "has empty info if there is no route between the cities" do
    
    params = {
      "origin": "Cincinatti, OH",
      "destination": "London, England",
      "api_key": @user.api_key
    }    

    post "/api/v0/road_trip", params: params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    expect(response.status).to eq(422)

    data = JSON.parse(response.body, symbolize_names: true)

    expected = {
      data: {
        id: nil,
        type: "road_trip",
        attributes: {
          start_city: "Cincinatti, OH",
          end_city: "London, England",
          travel_time: "impossible",
          weather_at_eta: {}
        }
      }
    }

    expect(data).to eq(expected)
  end

  it "can do BIG road trips" do
    params = {
      "origin": "Anchorage,Alaska",
      "destination": "Panama City, Panama",
      "api_key": @user.api_key
    }    

    post "/api/v0/road_trip", params: params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    expect(response).to be_successful
    expect(response.status).to eq(200)

    data = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(data[:attributes][:start_city]).to eq("Anchorage, AK")
    expect(data[:attributes][:end_city]).to eq("Ciudad de Panamá, PA")

    expect(data[:attributes]).to have_key(:travel_time)
    expect(data[:attributes][:travel_time]).to be_a(String)
    expect(data[:attributes][:travel_time]).to match(/\d{3}:\d{2}/) #expecting 100+ hours

    expect(data[:attributes][:weather_at_eta][:datetime]).to match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/)
    expect(data[:attributes][:weather_at_eta][:datetime].to_time > (Time.now + 4.days)).to eq(true)
  end
end