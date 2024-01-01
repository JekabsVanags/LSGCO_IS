class WeeklyActivitiesController < ApplicationController
  #Pārbauda vai lietotājs ir autorizējies un vai tam ir pieteikamas piekļuves
  before_action :authorized?, :unit_access?

  def create #Izveido jaunu iknedēļas nodarbību un pievieno pašreizējā lietotāja vienībai, ja nesaglabājas, paziņojums
    @activity = WeeklyActivity.new(weekly_activity_params)
    @activity.unit = current_user.unit
    if @activity.save!
      redirect_to edit_unit_path(current_user.unit), notice: "Iknedēļas nodarbība izveidota"
    else
      redirect_to edit_unit_path(current_user.unit), alert: "Kļūda"
    end
  end

  def destroy #Dzēšam iknedēļas nodarbību, ja neizdodas, paziņojums
    @activity = WeeklyActivity.find(params[:id])
    if @activity.delete
      redirect_to edit_unit_path(current_user.unit), notice: "Iknedēļas nodarbība dzēsta"
    else
      redirect_to edit_unit_path(current_user.unit), alert: "Kļūda"
    end
  end

  private

  #Pieņem iknedēļas nodarbības objektu, kas aizpildīts atļautajiem laukiem
  def weekly_activity_params
    params.require(:weekly_activity).permit(:day, :time, :rank)
  end
end
