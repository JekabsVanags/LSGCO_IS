class UnitController < ApplicationController
  before_action :authorized?
  before_action :unit_access?

  def show
    @unit = Unit.find(params[:id])
    @weekly_activity = @unit.weekly_activities.all
    @members = @unit.users
  end

  def edit
    @unit = Unit.find(params[:id])
    @weekly_activity = @unit.weekly_activities.all
  end

  def update
    @unit = Unit.find(params[:id])
    if @unit.update(unit_update_params)
      redirect_to root_path, notice: "Vienības infromācija atjaunota"
    else
      redirect_to root_path, notice: "Kļūda"
    end
  end

  protected

  def unit_create_params
    params.require(:unit).permit(:city, :number, :legal_adress, :bank_account, :comments)
  end

  def unit_update_params
    params.require(:unit).permit(:city, :number, :legal_adress, :activity_location_name, :email, :phone, :bank_account, :comments)
  end
end
