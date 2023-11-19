class EventsController < ApplicationController
  before_action :authorized?
  before_action :unit_access?, except: ["show"]

  def index
    session[:current_tab] = "events"
    @events = current_user.unit.events
    @invites = current_user.unit.invites.map(&:event).uniq
  end

  def show
    @event = Event.find(params[:id])
    @event_registration = EventRegistration.new
  end

  def show_unit
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new()
    @units = Unit.all.order(city: :asc)
  end

  def edit
    @event = Event.find(params[:id])
    @invites = Invite.where(event: @event)
    @invite = Invite.new()
    @units = Unit.all.map {|unit| [unit.full_name, unit.id]}
  end

  def create
    @unit = current_user.unit
    @event = Event.new(event_params.except(:units, :ranks))
    @event.unit = @unit
    
    if @event.save! && generate_invites(event_params[:units], event_params[:ranks], @event)
      redirect_to events_path, notice: "Pasākums izveidots"
    else
      redirect_to events_path, notice: "Kļūda"
    end
  end

  def update
    @event = Event.find(params[:id])

    if @event.update(event_params)
      redirect_to events_path, notice: "Pasākums atjaunots"
    else
      redirect_to events_path, notice: "Kļūda"
    end
  end

  def destroy
    @event = Event.find(params[:id])

    if @event.update(deleted_at: Time.now)
      redirect_to events_path, notice: "Pasākums atjaunots"
    else
      redirect_to events_path, notice: "Kļūda"
    end
  end

  protected

  def event_params
    params.require(:event).permit(:name, :description, :date_from, :date_to, :event_type, :necessary_volunteers, :max_participants, :deleted_at, units: [], ranks: [])
  end

  def generate_invites(units, ranks, event)
    ranks.each do |rank|
      units.each do |unit_id|
        unit = Unit.find(unit_id)
        Invite.create(rank:, unit:, event:)
      end
    end
  end
end
