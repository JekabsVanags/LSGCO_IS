class EventRegistrationsController < ApplicationController
  before_action :authorized?
  before_action :unit_access?, only: :destroy

  def create #Izveido jaunu reģistrāciju
    @registration = EventRegistration.new(registration_params)
    @registration.user = current_user
    @event = Event.find(registration_params[:event_id])

    #Ja lietotājs reģistrējas kā dalībnieks palielina dalībnieku skaitu, citi palielina brīvprātīgo skaitu
    if registration_params[:role] == "Dalībnieks"
      if !@event.max_participants || @event.max_participants > @event.registered_participants #Pasākuma kapacitāte nav sasniegta, ja ir paziņo
        @event.registered_participants += 1
      else
        redirect_to event_path(registration_params[:event_id]), notice: "Pārāk daudz dalībnieku"
        return
      end
    else
      if !@event.necessary_volunteers || @event.necessary_volunteers > @event.registered_volunteers #Pasākuma vajadzīgie brīvprātīgie nav savākti, ja ir paziņo
        @event.registered_volunteers += 1
      else
        redirect_to event_path(registration_params[:event_id]), notice: "Pieteikami brīvprātīgo"
        return
      end
    end

    if @registration.save! && @event.save! #Saglabājam pasākuma atjaunoto dalībnieku skaitu un reģistrāciju.
      redirect_to event_path(registration_params[:event_id]), notice: "Reģistrēta dalība"
    else
      redirect_to event_path(registration_params[:event_id]), alert: "Kļūda"
    end
  end

  def destroy #Dzēšam reģistrāciju
    @registration = EventRegistration.find(params[:id])
    @event = @registration.event

    #Samazinam pasākuma dalībnieku/brīvprātīgo skaitu
    if @registration.role == "Dalībnieks"
      @event.registered_participants -= 1
    else
      @event.registered_volunteers -= 1
    end

    #Saglabājam pasākuma atjaunoto dalībnieku skaitu un dzēšam reģistrāciju.
    if @registration.delete && @event.save!
      redirect_to event_registration_path(@event.id), notice: "Reģistrācija atsaukta"
    else
      redirect_to event_registration_path(@event.id), alert: "Kļūda"
    end
  end

  def show #Pasākuma reģistrācijas
    @event = Event.find(params[:id])

    #Ja lietotāja vienība vada pasākumu, rāda visas reģistrāciajas, ja nē, tad tikai lietotāja vienības biedru reģistrācijas.
    if @event.unit == current_user.unit
      @registrations = EventRegistration.where(event: @event)
    else
      @registrations = EventRegistration.joins(user: :unit).where(event: @event, units: { id: current_user.unit.id })
    end
  end

  private

  #Pieņem reģistrācijas objektu ar vērtībām
  def registration_params
    params.require(:event_registration).permit(:event_id, :role, :position, :private_info_permission)
  end
end
