class SessionController < ApplicationController
  before_action :authorized?, only: [:destory]

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to profile_path, notice: "Pieslēgšanās veiksmīga"
    else
      redirect_to root_path, alert: "Nepareiza parole vai lietotājvārds"
    end
  end

  def destory 
    session.clear
    redirect_to root_path, notice: "Izrakstīšanās veiksmīga"
  end

  def first_login
    @user = User.find(params[:id])
    @old_password = params[:password]
    @sidebar_state = @user.permission_level
    session[:user_id] = @user.created_at > Date.today-7 ? @user.id : nil
    session[:new_user] = true
    redirect_to root_path unless @user.authenticate(params[:password]) && @user.created_at == @user.updated_at && session[:user_id]
  end

end
