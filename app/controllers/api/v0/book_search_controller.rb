class Api::V0::BookSearchController < ApplicationController 
  def index 
    forecast = WeatherFacade.new.get_forecast(params[:location])
    book_results = BookSearchFacade.new.find_books(search_params)
    render json: BookSearchSerializer.new(forecast, book_results).to_json
  end

  private 

  def search_params
    params.permit(:location, :quantity)
  end
end