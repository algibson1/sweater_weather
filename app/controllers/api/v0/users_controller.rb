class Api::V0::UsersController < ApplicationController 
  def create 
    user = User.new(user_params)
    user.generate_key
    user.save!
    render json: UsersSerializer.new(user), status: :created
  end

  private 
  
  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end