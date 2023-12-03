require "rails_helper"

RSpec.describe EventsController, type: :controller do
  let(:unit) { create(:unit) }
  let(:unit2) { create(:unit) }
  let(:unit3) { create(:unit, deleted_at: Date.today) }
  let(:user) { create(:user, unit: unit, permission_level: "pklv_valde") }
  let(:user2) { create(:user, unit: unit, permission_level: "pklv_biedrs") }
  let(:user3) { create(:user, unit: unit3, permission_level: "pklv_valde") }
  let(:event) { create(:event, unit: unit) }
  let(:event2) { create(:event, unit: unit) }
  let(:invite) { create(:invite, unit: unit, event: event) }
  let(:invite2) { create(:invite, unit: unit, event: event2) }
  let(:invite3) { create(:invite, unit: unit2, event: event) }

  before do
    user.save!
    session[:user_id] = user.id
  end

  describe "GET #index" do
    it "Gets the events and invites" do
      unit.save!
      event.save!
      event2.save!
      invite.save!
      invite2.save!
      get :index

      expect(assigns(:events)).to eq([event, event2])
      expect(assigns(:invites)).to eq([event, event2])
      expect(session[:current_tab]).to eq("events")
    end
  end

  describe "GET #show" do
    it "gets event and event_registration" do
      get :show, params: { id: event.id }

      expect(assigns(:event)).to eq(event)
      expect(assigns(:event_registration)).to be_a_new(EventRegistration)
    end
  end

  describe "GET #show_unit" do
    it "gets event" do
      get :show_unit, params: { id: event.id }

      expect(assigns(:event)).to eq(event)
    end
  end

  describe "GET #new" do
    it "gets a new event and units" do
      get :new

      expect(assigns(:event)).to be_a_new(Event)
      expect(assigns(:units)).to eq(Unit.where(deleted_at: nil).order(city: :asc))
    end
  end

  describe "GET #edit" do
    it "gets event, invites, invite, and units" do
      unit.save!
      unit2.save!
      event.save!
      invite.save!
      invite3.save!

      get :edit, params: { id: event.id }

      expect(assigns(:event)).to eq(event)
      expect(assigns(:invites)).to eq([invite, invite3])
      expect(assigns(:invite)).to be_a_new(Invite)
      expect(assigns(:units)).to eq([[unit.full_name, unit.id], [unit2.full_name, unit2.id]])
    end
  end

  describe "POST #create" do
    it "creates an event and redirects to events path with notice and creates invites" do
      post :create, params: {
                      event: { name: "Test Event", date_from: Date.today, date_to: Date.tomorrow, necessary_volunteers: 2, max_participants: 2, event_type: "Pārgājiens", units: [unit.id],
                               ranks: ["SK/G", "MZSK/GNT"] },
                    }

      expect(response).to redirect_to(events_path)
      expect(flash[:notice]).to eq("Pasākums izveidots")
      expect(Event.count).to eq(1)
      expect(Invite.count).to eq(2)
    end

    it "creates an event with no invites and redirects to events path with notice" do
      post :create, params: {
                      event: { name: "Test Event", date_from: Date.today, date_to: Date.tomorrow, necessary_volunteers: 2, max_participants: 2, event_type: "Pārgājiens" },
                    }

      expect(response).to redirect_to(events_path)
      expect(flash[:notice]).to eq("Pasākums izveidots")
      expect(Event.count).to eq(1)
      expect(Invite.count).to eq(0)
    end

    it "cannot create without the permissions" do
      user2.save!
      session[:user_id] = user2.id

      post :create, params: {
                      event: { name: "Test Event", date_from: Date.today, date_to: Date.tomorrow, necessary_volunteers: 2, max_participants: 2, event_type: "Pārgājiens" },
                    }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Nav atļauts")
      expect(Event.count).to eq(0)
      expect(Invite.count).to eq(0)
    end

    it "cannot create if unit is innactive" do
      unit3.save!
      user3.save!
      session[:user_id] = user3.id

      post :create, params: {
                      event: { name: "Test Event", date_from: Date.today, date_to: Date.tomorrow, necessary_volunteers: 2, max_participants: 2, event_type: "Pārgājiens" },
                    }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Vienība neaktīva")
      expect(Event.count).to eq(0)
      expect(Invite.count).to eq(0)
    end
  end

  describe "PATCH #update" do
    it "updates an event and redirects to events path with notice" do
      patch :update, params: { id: event.id, event: { name: "Updated Event" } }
      event.reload

      expect(response).to redirect_to(events_path)
      expect(flash[:notice]).to eq("Pasākums atjaunots")
      expect(event.name).to eq("Updated Event")
    end

    it "redirects to events path with notice on update error" do
      allow_any_instance_of(Event).to receive(:update).and_return(false)

      patch :update, params: { id: event.id, event: { name: "Updated Event" } }
      event.reload

      expect(response).to redirect_to(events_path)
      expect(flash[:notice]).to eq("Kļūda")
      expect(event.name).not_to eq("Updated Event")
    end
  end

  describe "DELETE #destroy" do
    it "soft deletes an event and redirects to events path with notice" do
      delete :destroy, params: { id: event.id }
      event.reload

      expect(response).to redirect_to(events_path)
      expect(flash[:notice]).to eq("Pasākums atjaunots")
      expect(event.deleted_at).not_to be_nil
    end

    it "redirects to events path with notice on delete error" do
      allow_any_instance_of(Event).to receive(:update).and_return(false)

      delete :destroy, params: { id: event.id }
      event.reload

      expect(response).to redirect_to(events_path)
      expect(flash[:notice]).to eq("Kļūda")
      expect(event.deleted_at).to be_nil
    end
  end
end
