class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :is_signed_in

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # how to apply application level check: https://github.com/plataformatec/devise#controller-filters-and-helpers
  # https://stackoverflow.com/questions/36302866/how-do-i-make-a-before-action-to-run-on-all-controllers-and-actions-except-one
  # https://stackoverflow.com/questions/14086244/error-too-many-redirects
  def is_signed_in
    if session[:user_id].nil?
      redirect_to root_url
      return
    end
  end

  helper_method :current_user
end
