class SessionController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:login]

def login
    @user = User.find_by(username: params[:username])

    if @user && params[:password] == @user.password
      render json: { message: 'Login successful', username: @user.username }, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
end

end