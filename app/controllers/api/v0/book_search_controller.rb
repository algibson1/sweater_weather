class Api::V0::BookSearchController < ApplicationController 
  def index 
    require 'pry'; binding.pry
    render json: BookSearchSerializer.new(BookSearchFacade.new(search_params)).to_json
  end

  private 

  def search_params
    params.permit(:location, :quantity)
  end
end