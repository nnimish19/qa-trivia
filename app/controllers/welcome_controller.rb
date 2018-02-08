class WelcomeController < ApplicationController
  skip_before_action :is_signed_in, only: [:index]

  def index
    render 'games/index' unless current_user.nil?
  end
end
