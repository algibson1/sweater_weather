class Api::V0::ForecastController < ApplicationController 
  def index
    forecast = WeatherFacade.new.get_forecast(params[:location])
    render json: ForecastSerializer.new(forecast).to_json
  end
end