class SessionController < ApplicationController
  #Lai atteiktos ir jābūt pieteikušamies
  before_action :authorized?, only: [:destroy]

  def create #Autorizē lietotāju
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password]) && user.activity_statuss != "Izstājies" #Ja lietotāja parole pareiza un lietotājs aktīvs atjauno sesiju un pārvirzam ar paziņojumiem.
      session[:user_id] = user.id
      redirect_to profils_path, notice: "Pieslēgšanās veiksmīga"
    else
      redirect_to root_path, alert: "Nepareiza parole vai lietotājvārds"
    end
  end

  def destroy #Atteikšanās
    session.clear
    redirect_to root_path, notice: "Izrakstīšanās veiksmīga"
  end

  def first_login #Lietotāja reģistrācijas pabeigšana
    session.clear #Sākam jaunu sesiju
    @user = User.find(params[:id])
    @old_password = params[:password]
    session[:user_id] = @user.created_at > Date.today - 7 ? @user.id : nil #Reģistrācijas saite derīga 7 dienas
    session[:new_user] = true #Parametrs vēlākai apstrādei

    #Pārbaude vai lietotāja pagaidu parole pareiza, lietotājs nav mainīts un lietotājs ir atrasts
    return if @user.authenticate(params[:password]) && @user.created_at == @user.updated_at && session[:user_id]

    #Nesekmīga pieslēgšanās
    session.clear
    redirect_to root_path
  end

  def password_reset #Lietotāja paroles atjuanošana
    @user = User.find(params[:id])
    @old_password = params[:password]
    session[:password_reset] = true
    session[:user_id] = @user.updated_at > Date.today - 7 ? @user.id : nil #Paroles atiestatīšanas saite derīga 7 dienas

    #Pārbaude vai lietotāja pagaidu parole pareiza un lietotājs ir atrasts
    return if @user.authenticate(params[:password]) && session[:user_id]

    #Nesekmīga pieslēgšanās
    session.clear
    redirect_to root_path
  end
end
