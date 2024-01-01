class InvitesController < ApplicationController
  #Pārbauda vai lietotājs ir autorizējies un ar vienības piekļuves līmeni vai augstāk
  before_action :authorized?, :unit_access?

  def create #Izveido ielūgumu ja tāds jau neeksistē, ja neizdodas saglabāt, paziņo.
    if Invite.where({ rank: invite_params[:rank], unit: Unit.find(invite_params[:unit]), event: Event.find(invite_params[:event]) }).present?
      redirect_to edit_event_path(invite_params[:event]), notice: "Ielūgums jau eksistē"
      return
    end

    @invite = Invite.new({ rank: invite_params[:rank], unit: Unit.find(invite_params[:unit]), event: Event.find(invite_params[:event]) })

    if @invite.save!
      redirect_to edit_event_path(invite_params[:event]), notice: "Ielūgums izveidots"
    else
      redirect_to edit_event_path(invite_params[:event]), alert: "Kļūda"
    end
  end

  def destroy #Dzēš ielūgumu, ja neizdodas paziņo
    @invite = Invite.find(params[:id])
    @event = @invite.event
    if @invite.delete
      redirect_to edit_event_path(@event), notice: "Ielūgums dzēsts"
    else
      redirect_to edit_event_path(@event), alert: "Kļūda"
    end
  end

  private

  #Pieņem ielūguma objektu ar atļautajiem laukiem
  def invite_params
    params.require(:invite).permit(:rank, :unit, :event)
  end
end
