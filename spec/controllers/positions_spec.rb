require "rails_helper"

RSpec.describe PositionsController, type: :controller do
  let(:unit) { create(:unit) }
  let(:user) { create(:user, unit: unit) }
  let(:current_user) { create(:user, unit: unit, permission_level: "pklv_valde") }
  let(:position1) { create(:position, user: user, unit: unit) }
  let(:position2) { create(:position, user: user, unit: unit) }

  before do
    current_user.save!
    session[:user_id] = current_user.id
  end

  describe "POST #create" do
    it "creates new position in unit and assigns it to user and redirects" do
      post :create, params: { position: { position_name: "tester", user_id: user } }

      expect(user.positions[0].position_name).to eq("tester")
      expect(unit.positions.length).to eq(1)

      expect(response).to redirect_to(user_path(user))
    end

    it "redirects to root path if user doesnt have the permissions" do
      session[:user_id] = user.id

      post :create, params: { position: { position_name: "tester", user_id: current_user } }

      expect(response).to redirect_to(root_path)
    end
  end

  describe "DELETE #destroy" do
    it "deletes a position and redirects" do
      position1.save!
      position2.save!

      expect(user.positions.length).to eq(2)

      delete :destroy, params: { id: position1.id }
      user.reload
      expect(user.positions.length).to eq(1)
      expect(unit.positions.length).to eq(1)

      expect(response).to redirect_to(user_path(user))
    end
  end
end
