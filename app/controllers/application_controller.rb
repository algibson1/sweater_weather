class ApplicationController < ActionController::API
  rescue_from ActionController::BadRequest, with: :bad_request_response
  rescue_from ActiveRecord::RecordNotFound, with: :unauthorized_response

  def bad_request_response(error)
    render json: ErrorSerializer.new(error).to_json, status: :bad_request
  end

  def unauthorized_response(error)
    render json: ErrorSerializer.new(error).to_json, status: :unauthorized
  end
end
