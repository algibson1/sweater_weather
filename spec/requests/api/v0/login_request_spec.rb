require "rails_helper"

RSpec.describe "User log in endpoint" do
  before(:each) do
    @user = User.create(email: "whatever@example.com", password: "password", password_confirmation: "password", api_key: "random_key")
  end

  it "logs in a user" do

    params = {
      "email": "whatever@example.com",
      "password": "password"
    }

    post "/api/v0/sessions", params: params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    expect(response).to be_successful
    expect(response.status).to eq(200)

    data = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(data).to have_key(:type)
    expect(data[:type]).to eq("users")
    expect(data).to have_key(:id)
    expect(data[:id].to_i).to eq(@user.id)
    expect(data).to have_key(:attributes)
    expect(data[:attributes]).to have_key(:email)
    expect(data[:attributes][:email]).to eq("whatever@example.com")
    expect(data[:attributes]).to have_key(:api_key)
    expect(data[:attributes][:api_key]).to eq("random_key")
  end

  it "returns an error if credentials are invalid (wrong password)" do

    params = {
      "email": "whatever@example.com",
      "password": "wrong_password"
    }

    post "/api/v0/sessions", params: params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    expect(response.status).to eq(401)
    
    message = JSON.parse(response.body, symbolize_names: true)
    expect(message).to eq({message: "Your credentials are invalid"})
  end

  it "returns an error if credentials are invalid (wrong email)" do
    params = {
      "email": "invalid_email",
      "password": "password"
    }

    post "/api/v0/sessions", params: params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    expect(response.status).to eq(401)
    
    message = JSON.parse(response.body, symbolize_names: true)
    expect(message).to eq({message: "Your credentials are invalid"})
  end

  it "returns an error if fields left blank" do

    params = {}

    post "/api/v0/sessions", params: params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    expect(response.status).to eq(401)
    
    message = JSON.parse(response.body, symbolize_names: true)
    expect(message).to eq({message: "Your credentials are invalid"})
  end
end