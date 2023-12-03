class StaticController < ApplicationController
  before_action :redirect_logged_in

  def landing
    @user_permission_level = "login"
    render "static/landing"
  end

  def redirect_logged_in
    return unless current_user.present?

    redirect_to profils_path
  end
end
