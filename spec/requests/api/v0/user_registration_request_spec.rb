require "rails_helper"

RSpec.describe "User registration endpoint" do
  it "registers a user" do
    params = {
        "email": "whatever@example.com",
        "password": "password",
        "password_confirmation": "password"
      }

    post "/api/v0/users", params: params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    expect(response).to be_successful
    expect(response.status).to eq(201)

    parsed = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(parsed[:type]).to eq("user")
    expect(parsed[:id]).to be_an(Integer)
    expect(parsed[:attributes][:email]).to eq("whatever@example.com")
    expect(parsed[:attributes][:api_key]).to be_a(String)

    user = User.last 
    expect(user.email).to eq("whatever@example.com")
    expect(user.id).to eq(parsed[:id])
    expect(user.api_key).to eq(parsed[:attributes][:api_key])
  end

  # test for invalid user: missing a field, passwords don't match, email not unique...
  # status code 400
end