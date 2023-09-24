class Api::V0::ForecastController < ApplicationController 
  def index
    # require 'pry'; binding.pry
    forecast = ForecastFacade.search_by_city(params[:location])
    render json: ForecastSerializer.new(forecast).as_json
  end
end