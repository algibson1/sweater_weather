class Api::V0::UsersController < ApplicationController 
  def create 
    user = User.new(user_params)
    user.generate_key
    begin 
      user.save!
      render json: UserSerializer.new(user), status: :created
    rescue ActiveRecord::RecordInvalid => error 
      return render json: ErrorSerializer.new(error).to_json, status: :unprocessable_entity if error.message.include?("taken") 
      render json: ErrorSerializer.new(error).to_json, status: :bad_request 
    end
  end

  private 
  
  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end