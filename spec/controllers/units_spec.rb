require "rails_helper"

RSpec.describe UnitsController, type: :controller do
  let(:unit) { create(:unit) }
  let(:unit2) { create(:unit) }
  let(:user) { create(:user, unit: unit, permission_level: "pklv_vaditajs") }

  before do
    session[:user_id] = user.id
  end

  #TBD INDEX + NEW + CREATE tests

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
