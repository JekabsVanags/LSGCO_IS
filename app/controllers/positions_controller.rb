class PositionsController < ApplicationController
  before_action :authorized?, :unit_access?

  def create
    @position = Position.new(position_params)
    @position.unit = current_user.unit
    if @position.save!
      redirect_to user_path(position_params[:user_id]), notice: "Amats izveidots"
    else
      redirect_to user_path(position_params[:user_id]), alert: "Kļūda"
    end
  end

  def destroy
    @position = Position.find(params[:id])
    @user = @position.user_id
    if @position.delete
      redirect_to user_path(@user), notice: "Amats dzēsts"
    else
      redirect_to user_path(@user), alert: "Kļūda"
    end
  end

  private

  def position_params
    params.require(:position).permit(:position_name, :user_id)
  end
end
