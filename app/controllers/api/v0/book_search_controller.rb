class Api::V0::BookSearchController < ApplicationController
  before_action :validate_location
  before_action :validate_quantity
  rescue_from ActionController::BadRequest, with: :bad_request_response

  def index 
    forecast = WeatherFacade.new.get_forecast(params[:location])
    book_results = BookSearchFacade.new.find_books(search_params)
    render json: BookSearchSerializer.new(forecast, book_results).to_json
  end

  private 

  def search_params
    params.permit(:location, :quantity)
  end

  def validate_quantity 
    unless params[:quantity].to_i > 0
      raise ActionController::BadRequest.new("Quantity must be a number greater than 0")
    end
  end

  def validate_location 
    unless params[:location]
      raise ActionController::BadRequest.new("Location cannot be blank")
    end
  end

  def bad_request_response(error)
    render json: {message: error.message}, status: :unprocessable_entity
  end
end