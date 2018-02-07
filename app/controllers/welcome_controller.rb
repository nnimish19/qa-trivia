class WelcomeController < ApplicationController
  skip_before_action :is_signed_in, only: [:index]

  def index
  end
end
