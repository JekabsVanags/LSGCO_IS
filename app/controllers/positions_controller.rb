class PositionsController < ApplicationController
  #Pārbauda vai lietotājs ir autorizējies
  before_action :authorized?, :unit_access?

  def create #Izveido amatu lietotājam un tā vienībai. Ja neizdodas ierakstu saglabāt paziņo
    @position = Position.new(position_params)
    @position.unit = User.find(position_params[:user_id]).unit
    if @position.save!
      redirect_to user_path(position_params[:user_id]), notice: "Amats izveidots"
    else
      redirect_to user_path(position_params[:user_id]), alert: "Kļūda"
    end
  end

  def destroy #Dzēš amatu, ja neizdodas paziņo
    @position = Position.find(params[:id])
    @user = @position.user_id
    if @position.delete
      redirect_to user_path(@user), notice: "Amats dzēsts"
    else
      redirect_to user_path(@user), alert: "Kļūda"
    end
  end

  private

  #Pieņem amata objektu ar atļautajiem laukiem
  def position_params
    params.require(:position).permit(:position_name, :user_id)
  end
end
