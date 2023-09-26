class Api::V0::RoadTripController < ApplicationController
  before_action :validate_key
  rescue_from ActiveRecord::RecordNotFound, with: :unauthorized_response

  def create 
    render json: RoadTripSerializer.new(facade.get_trip_info)
  end

  private
  def facade 
    @facade = RoadTripFacade.new(road_trip_params)
  end

  def road_trip_params
    params.permit(:origin, :destination)
  end

  def validate_key
    unless User.find_by(api_key: params[:api_key])
      raise ActiveRecord::RecordNotFound, "Validation failed: Api key is not valid"
    end
  end

  def unauthorized_response(error)
    render json: ErrorSerializer.new(error).to_json, status: :unauthorized
  end
end