class ReportsController < ApplicationController
  before_action :unit_access?, :authorized?
  before_action :org_access?, only: ["member_report"]

  def unit_report
    session[:current_tab] = "unit_report"
    if params[:id]
      @unit = Unit.find(params[:id])
      @users = @unit.users
    else
      @units = Unit.where(deleted_at: nil).map { |unit| [unit.full_name, unit.id] }
    end
  end

  def member_report
    session[:current_tab] = "member_report"
    @users = User.all
  end
end
