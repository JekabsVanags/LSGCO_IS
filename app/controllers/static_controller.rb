class StaticController < ApplicationController
  before_action :redirect_logged_in

  def landing #Lietotāja piekļuves līmenis ļauj tikai autorizēties
    @user_permission_level = "login"
    render "static/landing"
  end

  def redirect_logged_in #Ja lietotājs ir reģistrējies root_path pārvirza uz lietotāja profilu
    return unless current_user.present?
    redirect_to profils_path
  end
end
