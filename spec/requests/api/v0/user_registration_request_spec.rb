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
    expect(parsed[:id]).to be_an(String)
    expect(parsed[:attributes][:email]).to eq("whatever@example.com")
    expect(parsed[:attributes][:api_key]).to be_a(String)

    user = User.last 
    expect(user.email).to eq("whatever@example.com")
    expect(user.id).to eq(parsed[:id].to_i)
    expect(user.api_key).to eq(parsed[:attributes][:api_key])
  end

  it "returns error message if any fields are missing" do
    params = {
      "email": "",
      "password": "",
      "password_confirmation": ""
    }

    post "/api/v0/users", params: params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    expect(response.status).to eq(400)

    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(parsed).to have_key(:errors)
    expect(parsed[:errors][0]).to have_key(:detail)
    expect(parsed[:errors][0][:detail]).to eq("Validation failed: Email can't be blank, Password can't be blank")
  end

  it "returns an error if password and confirmation do not match" do
    params = {
      "email": "something",
      "password": "asdfaafds",
      "password_confirmation": ""
    }

    post "/api/v0/users", params: params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    expect(response.status).to eq(400)

    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(parsed).to have_key(:errors)
    expect(parsed[:errors][0]).to have_key(:detail)
    expect(parsed[:errors][0][:detail]).to eq("Validation failed: Password confirmation doesn't match Password")
  end

  it "returns an error if email is not unique" do
    User.create(email: "something", password: "password", password: "password", api_key: "blahblahblah")

    params = {
      "email": "something",
      "password": "another_password",
      "password_confirmation": "another_password"
    }

    post "/api/v0/users", params: params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    expect(response.status).to eq(422)

    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(parsed).to have_key(:errors)
    expect(parsed[:errors][0]).to have_key(:detail)
    expect(parsed[:errors][0][:detail]).to eq("Validation failed: Email has already been taken")
  end
end