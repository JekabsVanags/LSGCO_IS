class PersonalInformationController < ApplicationController
  #Pārbauda vai lietotājs ir autorizējies
  before_action :authorized?

  def new #Tukša aptaujas lapa ar noklusētajām vērtībām, ko atrādīt formā
    @info = PersonalInformation.new()
    @info.health_issues = "-"
    @info.medication_during_event = "-"
    @info.psychological_features = "-"
    @info.diet = "-"
  end

  def create #Pašreizējam lietotājam piesaistam aptaujas lapu, ja neizdodas saglabāt Paziņo kļūdu.
    @info = PersonalInformation.new(personal_information_params)
    @info.user = current_user
    if @info.save
      redirect_to aptaujas_lapa_path, notice: "Aptaujas lapa saglabāta."
    else
      redirect_to aptaujas_lapa_path, alert: "Kļūda"
    end
  end

  def edit #Iegūstam pašreizējā lietotāja aptaujas lapu, ko atrādīt formā.
    @info = current_user.personal_information
  end

  def update #atjauno pašreizējā lietotāja aptaujas lapu, ja neizdodas saglabāt Paziņo kļūdu.
    @info = current_user.personal_information
    if @info.update(personal_information_params)
      redirect_to aptaujas_lapa_path, notice: "Aptaujas lapa atjaunota."
    else
      redirect_to aptaujas_lapa_path, alert: "Kļūda"
    end
  end

  def destroy #Dzēšam pašreizējā lietotāja aptaujas lapu, ja neizdodas dzēst Paziņo kļūdu.
    @info = current_user.personal_information
    if @info.delete
      redirect_to aptaujas_lapa_path, notice: "Aptaujas lapa dzēsta."
    else
      redirect_to aptaujas_lapa_path, alert: "Kļūda"
    end
  end

  def show #Lentenē aktīvā sadaļa aptaujas lapa, iegūstam pašreizējā lietotāja aptaujas lapu.
    session[:current_tab] = "private_info"
    @info = current_user.personal_information
  end

  def display #Pēc reģistrācijas ID atrodam lietotāja aptaujas lapu, ko atgriežam.
    @registration = EventRegistration.find(params[:id])
    @user = @registration.user
    @info = @user.personal_information
  end

  protected

  #Pieņem visus aptaujas lapas parametrus izņemot created at un updated at.
  def personal_information_params
    params.require(:personal_information).permit(PersonalInformation.column_names - ["created_at", "updated_at"])
  end
end
