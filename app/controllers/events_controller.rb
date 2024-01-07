class EventsController < ApplicationController
  #Pārbauda vai lietotājs ir autorizējies
  before_action :authorized?
  #Apskatīt pasākumu var jebkurš, pārējām darbībām jābūt ar vienības piekļuves līmeni vai augstāk
  before_action :unit_access?, except: ["show"]
  #Pasākumu izveidot var tikai aktīva vienība
  before_action :unit_active?, only: ["create"]


  helper RegistrationHelpers

  def index #Vienības pasākumu un pasākumu uz ko vienība ielūgta saraksts
    session[:current_tab] = "events"
    @events = current_user.unit.events
    @invites = current_user.unit.invites.map(&:event).uniq
  end

  def show #Pasākuma dati lietotājam
    @event = Event.find(params[:id])
    @event_registration = EventRegistration.new
  end

  def show_unit #Pasākuma dati vienībām
    @event = Event.find(params[:id])
  end

  def new #Tukšs pasākuma objekts ar ko aizpildīt jauna pasākuma formu
    @event = Event.new()
    @units = Unit.where(deleted_at: nil).where.not(number: 0).order(city: :asc) #Organizācijas vienības
  end

  def edit #Pasākuma objekts ar ko aizpildīt pasākuma datu atjaunošanas formu
    @event = Event.find(params[:id])
    @invites = Invite.where(event: @event) #Pasākuma ielūgumi
    @invite = Invite.new()
    @units = Unit.where(deleted_at: nil).where.not(number: 0).map {|unit| [unit.full_name, unit.id]} #Organizācijas vienības priekš izvēles
  end

  def create #Izveido pasākumu pašreizējā lietotāja vienībai un ielūgumus atzīmētajām vienībām un pakāpēm, ja kļūda paziņo
    @unit = current_user.unit
    @event = Event.new(event_params.except(:units, :ranks))
    @event.unit = @unit

    if @event.save! && generate_invites(event_params[:units], event_params[:ranks], @event)
      redirect_to events_path, notice: "Pasākums izveidots"
    else
      redirect_to events_path, alert: "Kļūda"
    end
  end

  def update #Atjauno pasākuma datus, ja neizdodas saglabāt, paziņo
    @event = Event.find(params[:id])

    if @event.update(event_params)
      redirect_to events_path, notice: "Pasākums atjaunots"
    else
      redirect_to events_path, alert: "Kļūda"
    end
  end

  def destroy #Nestingri dzēš pasākumu, dzēš ar to saistītos ielūgumus un reģistrācijas, ja neizdodas atjaunot pasākuma dzēšanas laiku, paziņo
    @event = Event.find(params[:id])

    if @event.update(deleted_at: Time.now) && delete_invites(@event) && delete_registrations(@event)
      redirect_to events_path, notice: "Pasākums dzēsts"
    else
      redirect_to events_path, alert: "Kļūda"
    end
  end

  protected

  #Pieņem pasākuma objektu ar atļautajiem laukiem
  def event_params
    params.require(:event).permit(:name, :description, :date_from, :date_to, :event_type, :necessary_volunteers, :max_participants, :deleted_at, units: [], ranks: [])
  end

  #Funkcija, kas izveido ielūgumus vienību masīva pakāpēm, kas pakāpju masīvā
  def generate_invites(units, ranks, event)
    return true unless units.present? && ranks.present?
    if units.present? && ranks.present?
      ranks.each do |rank|
        units.each do |unit_id|
          unit = Unit.find(unit_id)
          Invite.create(rank:, unit:, event:)
        end
      end
    end
  end

  #Funkcija, kas dzēš visus ielūgumus no pasākuma
  def delete_invites(event)
    event.invites.each do |invite|
      invite.delete
    end
  end

  #Funkcija, kas dzēš visas reģistrāciajas no pasākuma
  def delete_registrations(event)
    event.event_registrations.each do |registration|
      registration.delete
    end
  end
end
