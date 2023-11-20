class EventRegistrationsController < ApplicationController
  before_action :authorized?

  def create
    @registration = EventRegistration.new(registration_params)
    @registration.user = current_user
    if @registration.save!
      redirect_to event_path(registration_params[:event_id]), notice: "Reģistrēta dalība"
    else
      redirect_to event_path(registration_params[:event_id]), notice: "Kļūda"
    end
  end

  def destroy
    @registration = EventRegistration.find(params[:id])
    @event = @registration.event
    if @registration.delete
      redirect_to event_path(registration_params[:event_id]), notice: "Reģistrācija atsaukta"
    else
      redirect_to event_path(registration_params[:event_id]), notice: "Kļūda"
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
