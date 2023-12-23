class WeeklyActivitiesController < ApplicationController
  before_action :authorized?, :unit_access?

  def create
    @activity = WeeklyActivity.new(weekly_activity_params)
    @activity.unit = current_user.unit
    if @activity.save!
      redirect_to edit_unit_path(current_user.unit), notice: "Iknedēļas nodarbība izveidota"
    else
      redirect_to edit_unit_path(current_user.unit), alert: "Kļūda"
    end
  end

  def destroy
    @activity = WeeklyActivity.find(params[:id])
    if @activity.delete
      redirect_to edit_unit_path(current_user.unit), notice: "Iknedēļas nodarbība dzēsta"
    else
      redirect_to edit_unit_path(current_user.unit), alert: "Kļūda"
    end
  end

  private

  def weekly_activity_params
    params.require(:weekly_activity).permit(:day, :time, :rank)
  end
end
