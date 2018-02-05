class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_action :is_signed_in

  private

  # how to apply application level check: https://github.com/plataformatec/devise#controller-filters-and-helpers
  # def is_signed_in
  #   redirect_to root_url if session[:user_id].nil?
  # end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
