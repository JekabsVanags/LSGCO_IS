class StaticController < ApplicationController
  before_action :redirect_logged_in

  def landing 
    @sidebar_state = "login"
    render "static/landing"
  end

  def redirect_logged_in 
    if current_user.present?
      redirect_to profile_path
    end
  end
end
