class Api::V0::RoadTripController < ApplicationController
  before_action :validate_key, only: [:create]
  rescue_from ActiveRecord::RecordNotFound, with: :unauthorized_response

  def create 
    render json: RoadTripSerializer.new(trip), status: trip.status
  end

  private

  def trip 
    @trip ||= RoadTripFacade.new(road_trip_params).get_trip_info
  end

  def road_trip_params
    params.permit(:origin, :destination)
  end

  def validate_key
    unless User.find_by(api_key: params[:api_key])
      raise ActiveRecord::RecordNotFound, "Validation failed: Api key is missing or invalid"
    end
  end

  def unauthorized_response(error)
    render json: ErrorSerializer.new(error).to_json, status: :unauthorized
  end
end