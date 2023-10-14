class SessionController < ApplicationController
  before_action :authorized?, only: [:destory]

  def create
    if params[:username].include?("@")
      user = User.find_by(email: params[:username])
    else
      user = User.find_by(username: params[:username])
    end

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

end
