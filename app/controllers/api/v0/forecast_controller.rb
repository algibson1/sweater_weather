class Api::V0::ForecastController < ApplicationController
  rescue_from ActionController::BadRequest, with: :bad_request_response
  
  def index
    forecast = WeatherFacade.new.get_forecast(params[:location])
    render json: ForecastSerializer.new(forecast).to_json
  end

  def bad_request_response(error)
    render json: ErrorSerializer.new(error).to_json, status: :bad_request
  end
end