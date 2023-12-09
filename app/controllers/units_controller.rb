class UnitsController < ApplicationController
  before_action :authorized?, :unit_access?, :unit_member?
  before_action :org_access?, only: ["create", "index", "new", "destroy"]

  def new
    session[:current_tab] = "new_unit"
    @unit = Unit.new()
    @users = User.where(activity_statuss: "Vadītājs").map { |user| ["#{user.name} #{user.surname}", user.id] }
  end

  def index
    session[:current_tab] = "unit_list"
    @units = Unit.all
  end

  def show
    session[:current_tab] = "unit" unless session[:current_tab] == "unit_list"
    @unit = Unit.find(params[:id])
    @weekly_activities = @unit.weekly_activities.all.order(day: :asc)
    @members = @unit.users.where.not(activity_statuss: "Izstājies")
    @unit_leader = User.where(unit: @unit, permission_level: "pklv_vaditajs").first
  end

  def create
    @leader = User.find(params[:leader_id])
    @unit = Unit.new(unit_create_params)

    if @unit.save! && @leader.update(permission_level: "pklv_vaditajs", unit: @unit)
      redirect_to unit_path(@unit), notice: "Jauna vienība izveidota"
    else
      redirect_to root_path, notice: "Kļūda"
    end
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

  def destroy
    @unit = Unit.find(params[:id])
    if @unit.update(deleted_at: Date.today)
      redirect_to unit_path(@unit), notice: "Vienības atzīmēta kā neaktīva"
    else
      redirect_to root_path, notice: "Kļūda"
    end
  end

  def undestory
    @unit = Unit.find(params[:id])
    if @unit.update(deleted_at: nil)
      redirect_to unit_path(@unit), notice: "Vienības atzīmēta kā aktīva"
    else
      redirect_to root_path, notice: "Kļūda"
    end
  end

  protected

  def unit_create_params
    params.require(:unit).permit(:city, :number, :legal_adress, :bank_account)
  end

  def unit_update_params
    params.require(:unit).permit(:legal_adress, :activity_location_name, :email, :phone, :bank_account, :comments, :membership_fee)
  end

  def unit_member?
    redirect_to root_path, alert: "Nav atļauts" unless current_user.unit.id == params[:id].to_i || current_user.pklv_valde?
  end
end
