class PositionController < ApplicationController
  brefore_action :unit_access?

  def create
    @unit = current_user.unit
    @position = Position.new(position_params, unit: @unit)
    if @position.save!
      redirect_to user_path(@user), notice: "Pozīcija izveidota"
    else
      redirect_to user_path(@user), notice: "Kļūda"
    end
  end

  def destroy
    @position = Position.find(params[:id])
    @user = @position.user_id
    if @position.delete!
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
