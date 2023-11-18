class InvitesController < ApplicationController
  before_action :authorized?, :unit_access?

  def create
    @invite = Invite.new({ rank: invite_params[:rank], unit: Unit.find(invite_params[:unit]), event: Event.find(invite_params[:event]) })

    if @invite.save!
      redirect_to edit_event_path(invite_params[:event]), notice: "Ielūgums izveidota"
    else
      redirect_to edit_event_path(invite_params[:event]), notice: "Kļūda"
    end
  end

  def destroy
    @invite = Invite.find(params[:id])
    @event = @invite.event
    if @invite.delete
      redirect_to edit_event_path(@event), notice: "Ielūgums izveidota"
    else
      redirect_to edit_event_path(@event), notice: "Kļūda"
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:rank, :unit, :event)
  end
end
