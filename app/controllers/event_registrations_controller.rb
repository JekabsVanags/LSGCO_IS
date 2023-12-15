class EventRegistrationsController < ApplicationController
  before_action :authorized?
  before_action :unit_access?, only: :destroy

  def create
    @registration = EventRegistration.new(registration_params)
    @registration.user = current_user
    @event = Event.find(registration_params[:event_id])

    if registration_params[:role] == "Dalībnieks"
      if !@event.max_participants || @event.max_participants > @event.registered_participants
        @event.registered_participants += 1
      else
        redirect_to event_path(registration_params[:event_id]), notice: "Pārāk daudz dalībnieku"
        return
      end
    else
      if !@event.necessary_volunteers || @event.necessary_volunteers > @event.registered_volunteers
        @event.registered_volunteers += 1
      else
        redirect_to event_path(registration_params[:event_id]), notice: "Pieteikami brīvprātīgo"
        return
      end
    end

    if @registration.save! && @event.save!
      redirect_to event_path(registration_params[:event_id]), notice: "Reģistrēta dalība"
    else
      redirect_to event_path(registration_params[:event_id]), alert: "Kļūda"
    end
  end

  def destroy
    @registration = EventRegistration.find(params[:id])
    @event = @registration.event

    if @registration.role == "Dalībnieks"
      @event.registered_participants -= 1
    elsif @registration.role == "Brīvprātīgais"
      @event.registered_volunteers -= 1
    end

    if @registration.delete && @event.save!
      redirect_to event_path(@event.id), notice: "Reģistrācija atsaukta"
    else
      redirect_to event_path(@event.id), alert: "Kļūda"
    end
  end

  def show
    @event = Event.find(params[:id])

    if @event.unit == current_user.unit
      @registrations = EventRegistration.where(event: @event)
    else
      @registrations = EventRegistration.joins(user: :unit).where(event: @event, units: { id: current_user.unit.id })
    end
  end

  private

  def registration_params
    params.require(:event_registration).permit(:event_id, :role, :position, :private_info_permission)
  end
end
