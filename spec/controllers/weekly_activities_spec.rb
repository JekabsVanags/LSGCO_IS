require "rails_helper"

RSpec.describe WeeklyActivitiesController, type: :controller do
  let(:unit) { create(:unit) }
  let(:user) { create(:user, unit: unit) }
  let(:current_user) { create(:user, unit: unit, permission_level: "pklv_valde") }
  let(:weekly_activity1) { create(:weekly_activity, unit: unit) }
  let(:weekly_activity2) { create(:weekly_activity, unit: unit) }

  before do
    current_user.save!
    session[:user_id] = current_user.id
  end

  describe "POST #create" do
    it "creates new position in unit and assigns it to user and redirects" do
      post :create, params: { weekly_activity: { time: Time.now, day: "Pirmdiena", rank: "Mazskauti/Guntiņas" } }

      expect(unit.weekly_activities.length).to eq(1)
      expect(unit.weekly_activities[0].day).to eq("Pirmdiena")
      expect(unit.weekly_activities[0].rank).to eq("Mazskauti/Guntiņas")

      expect(response).to redirect_to(edit_unit_path(unit))
    end

    it "redirects to root path if user doesnt have the permissions" do
      session[:user_id] = user.id

      post :create, params: { weekly_activity: { time: Time.now, day: "Pirmdiena", rank: "Mazskauti/Guntiņas" } }

      expect(response).to redirect_to(root_path)
    end
  end

  describe "DELETE #destroy" do
    it "deletes a position and redirects" do
      weekly_activity1.save!
      weekly_activity2.save!

      expect(unit.weekly_activities.length).to eq(2)

      delete :destroy, params: { id: weekly_activity1.id }
      unit.reload
      expect(unit.weekly_activities.length).to eq(1)

      expect(response).to redirect_to(edit_unit_path(unit))
    end
  end
end
