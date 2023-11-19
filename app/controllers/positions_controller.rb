class PositionsController < ApplicationController
  before_action :unit_access?, :authorized?

  def create
    @position = Position.new(position_params)
    @position.unit = current_user.unit
    if @position.save!
      redirect_to user_path(position_params[:user_id]), notice: "Pozīcija izveidota"
    else
      redirect_to user_path(position_params[:user_id]), notice: "Kļūda"
    end
  end

  def destroy
    @position = Position.find(params[:id])
    @user = @position.user_id
    if @position.delete
      redirect_to user_path(@user), notice: "Pozīcija dzēsta"
    else
      redirect_to user_path(@user), notice: "Kļūda"
    end
  end

  private

  def position_params
    params.require(:position).permit(:position_name, :user_id)
  end
end
