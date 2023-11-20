require "rails_helper"

RSpec.describe InvitesController, type: :controller do
  let(:unit) { create(:unit) }
  let(:user) { create(:user, unit: unit, permission_level: "pklv_valde") }
  let(:user1) { create(:user, unit: unit, permission_level: "pklv_biedrs") }
  let(:event) { create(:event, unit: unit) }
  let(:invite) { create(:invite, event: event, unit: unit) }

  before do
    user.save!
    session[:user_id] = user.id
  end

  describe "POST #create" do
    it "creates an invite and redirects to edit event path with notice" do
      post :create, params: { invite: { rank: "SK/G", unit: unit.id, event: event.id } }

      expect(response).to redirect_to(edit_event_path(event))
      expect(flash[:notice]).to eq("Ielūgums izveidota")
    end

    it "user with insuffisient permissions cannot create an invite" do
      user1.save!
      session[:user_id] = user1.id

      post :create, params: { invite: { rank: "SK/G", unit: unit.id, event: event.id } }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Nav atļauts")
    end
  end

  describe "DELETE #destroy" do
    it "deletes the invite and redirects to edit event path with notice" do
      delete :destroy, params: { id: invite.id }

      expect(response).to redirect_to(edit_event_path(event))
      expect(flash[:notice]).to eq("Ielūgums dzēsts")
    end

    it "redirects to edit event path with notice on delete error" do
      allow_any_instance_of(Invite).to receive(:delete).and_return(false)
      delete :destroy, params: { id: invite.id }

      expect(response).to redirect_to(edit_event_path(event))
      expect(flash[:notice]).to eq("Kļūda")
    end
  end
end
