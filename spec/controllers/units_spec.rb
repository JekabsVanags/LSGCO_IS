require "rails_helper"

RSpec.describe UnitsController, type: :controller do
  !let(:unit) { create(:unit) }
  !let(:unit2) { create(:unit) }
  !let(:user) { create(:user, unit: unit, activity_statuss: "Vadītājs", permission_level: "pklv_vaditajs") }
  !let(:leader) { create(:user, unit: unit, activity_statuss: "Vadītājs") }
  !let(:admin) { create(:user, unit: unit, permission_level: "pklv_valde") }

  before do
    session[:user_id] = user.id
  end

  describe "GET #index" do
    it "gets the list of units" do
      session[:user_id] = admin.id
      unit.save!
      unit2.save!

      get :index
      expect(assigns(:units)).to eq(Unit.all)
      expect(assigns(:units).length).to eq(2)
      expect(session[:current_tab]).to eq("unit_list")
      expect(response).to render_template(:index)
    end

    it "doesnt get the list without permissions" do
      get :index
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #new" do
    it "redirects to new unit form" do
      session[:user_id] = admin.id
      get :new
      expect(session[:current_tab]).to eq("new_unit")
      expect(assigns(:unit)).to be_a_new(Unit)
      expect(response).to render_template(:new)
    end

    it "gets a list of users with activity_status 'Vadītājs'" do
      session[:user_id] = admin.id
      other_user = create(:user, activity_statuss: "Vadītājs", unit: unit)
      get :new
      expect(assigns(:users)).to include(["#{other_user.name} #{other_user.surname}", other_user.id], ["#{user.name} #{user.surname}", user.id])
    end

    it "doesnt lead to new unit creation without permission" do
      get :new
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST #create" do
    it "creates a new unit and updates the leader" do
      session[:user_id] = admin.id
      post :create, params: { leader_id: leader.id, unit: { city: "Latvija", number: 0, legal_adress: "Edvarda Smiļģa iela 48",
                                                           email: "info@skautiungaidas.lv", bank_account: "GB59BARC20038041146187", membership_fee: "0" } }

      expect(Unit.count).to eq(2)

      leader.reload
      expect(leader.permission_level).to eq("pklv_vaditajs")
      expect(leader.unit).to eq(Unit.last)

      expect(response).to redirect_to(unit_path(Unit.last))
      expect(flash[:notice]).to eq("Jauna vienība izveidota")
    end

    it "does not create a new unit and does not update the leader" do
      session[:user_id] = admin.id
      expect { post :create, params: { leader_id: leader.id, unit: { name: nil } } }.to raise_error(ActiveRecord::RecordInvalid)

      expect(Unit.count).to eq(1)

      leader.reload
      expect(leader.permission_level).to_not eq("pklv_vaditajs")
      expect(leader.unit).to eq(unit)
    end
  end

  describe "DELETE #destroy" do
    it "marks a unit as innactive (soft delete)" do
      session[:user_id] = admin.id
      delete :destroy, params: { id: unit.id }

      unit.reload

      expect(unit.deleted_at).to_not be(nil)
    end
  end

  describe "PATCH #undestory" do
    it "marks a unit as active (reverses soft delete)" do
      session[:user_id] = admin.id
      patch :undestory, params: { id: unit.id }

      unit.reload

      expect(unit.deleted_at).to be(nil)
    end
  end

  describe "GET #show" do
    it "gets unit, weekly activities, members, and unit leader" do
      get :show, params: { id: unit.id }

      expect(assigns(:unit)).to eq(unit)
      expect(assigns(:weekly_activities)).to eq(unit.weekly_activities.order(day: :asc))
      expect(assigns(:members)).to eq(unit.users)
      expect(assigns(:unit_leader)).to eq(user)
    end

    it "return to root if user isnt of the unit" do
      get :show, params: { id: unit2.id }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Nav atļauts")
    end

    it "sets the current tab to 'unit'" do
      get :show, params: { id: unit.id }

      expect(session[:current_tab]).to eq("unit")
    end
  end

  describe "GET #edit" do
    it "gets unit, weekly activities, and a new activity" do
      get :edit, params: { id: unit.id }

      expect(assigns(:unit)).to eq(unit)
      expect(assigns(:weekly_activities)).to eq(unit.weekly_activities.order(day: :asc))
      expect(assigns(:new_activity)).to be_a_new(WeeklyActivity)
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      it "updates the unit and redirects to show page with notice" do
        patch :update, params: { id: unit.id, unit: { comments: "New City" } }

        unit.reload
        expect(unit.comments).to eq("New City")
        expect(response).to redirect_to(unit_path(unit))
        expect(flash[:notice]).to eq("Vienības infromācija atjaunota")
      end
    end

    it "with invalid params redirects to root path with notice" do
      allow_any_instance_of(Unit).to receive(:update).and_return(false)

      patch :update, params: { id: unit.id, unit: { city: "New City" } }

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Kļūda")
    end
  end
end
