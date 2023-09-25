class Api::V0::SessionsController < ApplicationController 
  def create 
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: UsersSerializer.new(user)
    else
      render json: {message: "Your credentials are invalid"}, status: 401
    end
  end
end