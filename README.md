# About This Project

This is the [final solo project of Turing School of Sofware and Design's Module 3 curriculum](https://backend.turing.edu/module3/projects/sweater_weather/requirements). 

The Learning Goals for this project include the following:
- Expose an API that aggregates data from multiple external APIs
- Expose an API that requires an authentication token
- Expose an API for CRUD functionality
- Determine completion criteria based on the needs of other developers
- Test both API consumption and exposure, making use of at least one mocking tool (VCR, Webmock, etc).


## Running on
* Ruby 3.2.2
* Rails 7.0.8


## Getting Started
Follow instructions below to get a local copy:

Clone this project
``` 
git@github.com:algibson1/sweater_weather.git
```

Install gems
```
bundle install
```

Create database
```
rails db:{create,migrate}
```

You will need to get your own keys from the following APIs.
* [Mapquest](https://developer.mapquest.com/documentation/geocoding-api/)
* [Weather API](https://www.weatherapi.com/)

When you have an API key, delete the existing credentials.yml.enc file and then run the following in the command line to open the credentials editor
``` 
EDITOR="code --wait" bin/rails credentials:edit
```
This should generate a new credentials file. Put your API keys in to the file in the following format:
```yml
mapquest:
  key: <YOUR_KEY_HERE>

weather:
  key: <YOUR_KEY_HERE>

```

Close the editor when finished to generate a master.key file. You can now use these credentials as either of the following:
```ruby
Rails.application.credentials.mapquest[:key]
Rails.application.credentials.weather[:key]
```

Add your personal credentials file to your .gitignore if contributing to this project.

## Endpoints
This project exposes four endpoints to a fictional front-end team creating an application that displays weather information.

All responses are compliant with JSON API 1.0.

### Landing Page
```
get "/api/v0/forecast?location=denver,co"
```
This endpoint takes in a search query from the front end user for a location. This back end needs to connect to the [Mapquest Geocoding API](https://developer.mapquest.com/documentation/geocoding-api/) to first fetch coordinates of the location, and then use those coordinates to find weather data about that location through the [Weather API](https://www.weatherapi.com/).

The weather information is then packaged up in a JSON that holds details about the current weather, the daily weather forecast for the next five days, and the hourly weather forecast for the current day.

### User Registration
```
post "api/v0/users"
```
This endpoint accepts a JSON payload in the request body, containing a user's email, password, and password confirmation. The back end validates the user email is unique and the passwords match, then registers the user, generates a unique api_key for that user, and sends back a JSON containing that user's email and api_key.

### User Login
```
post "api/v0/sessions"
```

This endpoint accepts a JSON payload in the request body, containing a user's email and password. If these are valid credentials based on users already registered with the system, it sends back a JSON that contains the user's email and api_key.

### Road Trip 
``` 
post "/api/v0/road_trip"
```

This endpoint accepts a JSON payload in the request body, containing an origin location, destination location, and a user's api key. If the key is valid, the endpoint will response with a JSON containing information about the driving travel time between the two points, and what the weather will be upon arrival after that amount of time.