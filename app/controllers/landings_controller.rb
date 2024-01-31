class LandingsController < ApplicationController
  skip_before_action :require_name
  skip_before_action :authenticate_user!

  def home
    redirect_to posts_path if user_signed_in?
  end
end
