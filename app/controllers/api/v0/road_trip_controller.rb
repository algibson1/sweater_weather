class Api::V0::RoadTripController < ApplicationController
  before_action :validate_key

  def create 
    render json: RoadTripSerializer.new(RoadTripFacade.new(road_trip_params))
  end

  def road_trip_params
    params.permit(:origin, :destination)
  end

  def validate_key
    User.find_by!(api_key: params[:api_key])
  end
end