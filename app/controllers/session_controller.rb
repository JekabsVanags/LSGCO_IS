class SessionController < ApplicationController
  before_action :authorized?, only: [:destroy]

  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password]) && user.activity_statuss != "Izstājies"
      session[:user_id] = user.id
      redirect_to profils_path, notice: "Pieslēgšanās veiksmīga"
    else
      redirect_to root_path, alert: "Nepareiza parole vai lietotājvārds"
    end
  end

  def destroy
    session.clear
    redirect_to root_path, notice: "Izrakstīšanās veiksmīga"
  end

  def first_login
    session.clear
    @user = User.find(params[:id])
    @old_password = params[:password]
    session[:user_id] = @user.created_at > Date.today - 7 ? @user.id : nil
    session[:new_user] = true
    return if @user.authenticate(params[:password]) && @user.created_at == @user.updated_at && session[:user_id]
    session.clear

    redirect_to root_path
  end

  def password_reset
    @user = User.find(params[:id])
    @old_password = params[:password]
    session[:user_id] = @user.updated_at > Date.today - 7 ? @user.id : nil
    return if @user.authenticate(params[:password]) && session[:user_id]

    redirect_to root_path
  end
end
