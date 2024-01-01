require "rails_helper"

RSpec.describe EventRegistrationsController, type: :controller do
  let(:unit) { create(:unit) }
  let(:user) { create(:user, unit: unit, permission_level: "pklv_valde") }
  let(:event) { create(:event, unit: unit, max_participants: 2, necessary_volunteers: 2) }
  let(:event_registration) { build(:event_registration, user: user, event: event, role: "Dalībnieks") }

  before do
    session[:user_id] = user.id
  end

  describe "POST #create" do
    it "creates an event registration and updates event counts" do
      post :create, params: { event_registration: { event_id: event.id, role: "Dalībnieks" } }
      event.reload

      expect(response).to redirect_to(event_path(event.id))
      expect(flash[:notice]).to eq("Reģistrēta dalība")
      expect(EventRegistration.count).to eq(1)
      expect(event.registered_participants).to eq(1)
    end

    it "creates an event registration for a volunteer and updates event counts" do
      post :create, params: { event_registration: { event_id: event.id, role: "Brīvprātīgais" } }
      event.reload

      expect(response).to redirect_to(event_path(event.id))
      expect(flash[:notice]).to eq("Reģistrēta dalība")
      expect(EventRegistration.count).to eq(1)
      expect(event.registered_volunteers).to eq(1)
    end

    it "doesnt create registration if participant limit reached" do
      event_registration.save!
      event.update(registered_participants: 2, registered_volunteers: 2)
      event.reload
      post :create, params: { event_registration: { event_id: event.id, role: "Dalībnieks" } }

      expect(response).to redirect_to(event_path(event.id))
      expect(flash[:notice]).to eq("Pārāk daudz dalībnieku")
      expect(EventRegistration.count).to eq(1)
      expect(event.registered_participants).to eq(2)

      post :create, params: { event_registration: { event_id: event.id, role: "Brīvprātīgais" } }

      expect(response).to redirect_to(event_path(event.id))
      expect(flash[:notice]).to eq("Pieteikami brīvprātīgo")
      expect(EventRegistration.count).to eq(1)
      expect(event.registered_volunteers).to eq(2)
    end
  end

  describe "DELETE #destroy" do
    before { event.update(registered_participants: 1) }

    it "deletes an event registration and updates event counts" do
      event_registration.save!
      delete :destroy, params: { id: event_registration }
      event.reload

      expect(response).to redirect_to(event_registration_path(event.id))
      expect(flash[:notice]).to eq("Reģistrācija atsaukta")
      expect(EventRegistration.count).to eq(0)
      expect(event.registered_participants).to eq(0)
    end

    it "redirects to event path with notice on delete error" do
      event_registration.save!
      allow_any_instance_of(EventRegistration).to receive(:delete).and_return(false)

      delete :destroy, params: { id: event_registration }
      event.reload

      expect(response).to redirect_to(event_registration_path(event.id))
      expect(flash[:alert]).to eq("Kļūda")
      expect(EventRegistration.count).to eq(1)
      expect(event.registered_participants).to eq(1)
    end
  end

  describe "GET #show" do
    it "gets registrations for the event for the current user's unit" do
      registration = create(:event_registration, user: user, event: event)
      other_unit = create(:unit)
      other_user = create(:user, unit: other_unit)
      other_registration = create(:event_registration, user: other_user, event: event)

      session[:user_id] = other_user.id

      get :show, params: { id: event.id }
      expect(assigns(:event)).to eq(event)
      expect(assigns(:registrations)).to contain_exactly(other_registration)
    end

    it "gets all registrations for event if current user is the organizer units member" do
      registration = create(:event_registration, user: user, event: event)
      other_unit = create(:unit)
      other_user = create(:user, unit: other_unit)
      other_registration = create(:event_registration, user: other_user, event: event)

      get :show, params: { id: event.id }
      expect(assigns(:event)).to eq(event)
      expect(assigns(:registrations)).to eq([registration, other_registration])
    end
  end
end
