class SessionsController < ApplicationController
  def create
    Rails.logger.info("\n---------------------Session: create---------------------\n")
    # Rails.logger.info(request.env["omniauth.auth"])   #Do not log this

    user = User.from_omniauth(request.env["omniauth.auth"])


    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end