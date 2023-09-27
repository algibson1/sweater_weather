class ApplicationController < ActionController::API
  rescue_from ActionController::BadRequest, with: :bad_request_response
  rescue_from ActiveRecord::RecordNotFound, with: :unauthorized_response
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_response

  def bad_request_response(error)
    render json: ErrorSerializer.new(error).to_json, status: :bad_request
  end

  def unauthorized_response(error)
    render json: ErrorSerializer.new(error).to_json, status: :unauthorized
  end

  def invalid_response(error)
    return render json: ErrorSerializer.new(error).to_json, status: :unprocessable_entity if error.message.include?("taken") 
    return bad_request_response(error)
  end
end
