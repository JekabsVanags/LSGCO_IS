class UnitController < ApplicationController
  before_action :authorized?
  before_action :unit_access?
  before_action :unit_member?

  def show
    @unit = Unit.find(params[:id])
    @weekly_activities = @unit.weekly_activities.all.order(day: :asc)
    @members = @unit.users
    @unit_leader = User.where(unit: @unit, permission_level: "pklv_vaditajs").first
  end

  def edit
    @unit = Unit.find(params[:id])
    @weekly_activities = @unit.weekly_activities.all.order(day: :asc)
    @new_activity = WeeklyActivity.new
  end

  def update
    @unit = Unit.find(params[:id])
    if @unit.update(unit_update_params)
      redirect_to unit_path(@unit), notice: "Vienības infromācija atjaunota"
    else
      redirect_to root_path, notice: "Kļūda"
    end
  end

  protected

  def unit_create_params
    params.require(:unit).permit(:city, :number, :legal_adress, :bank_account, :comments)
  end

  def unit_update_params
    params.require(:unit).permit(:city, :number, :legal_adress, :activity_location_name, :email, :phone, :bank_account, :comments, :membership_fee)
  end

  def unit_member?
    redirect_to root_path, alert: "Nav atļauts" unless current_user.unit.id == params[:id].to_i || current_user.pklv_valde?
  end
end
