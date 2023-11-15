require "rails_helper"

RSpec.describe MembershipFeePaymentsController, type: :controller do
  let(:unit) { create(:unit) }
  let(:user) { create(:user, unit: unit) }
  let(:user2) { create(:user, unit: unit, permission_level: "pklv_valde") }
  let(:current_user) { create(:user, unit: unit, permission_level: "pklv_valde") }
  let(:payment) { create(:membership_fee_payment, user_payed: user, user_recorded: current_user, unit: unit, amount: 10) }

  before do
    current_user.save!
    session[:user_id] = current_user.id
  end

  describe "POST #create" do
    it "creates new payment and redirects" do
      post :create, params: { membership_fee_payment: { user_payed: user.id, amount: 10, date: Date.today } }

      user.reload

      expect(user.payed_fees.length).to eq(1)
      expect(user.membership_fee_bilance).to eq(10)

      expect(response).to redirect_to(list_membership_fee_payment_path(user))
    end

    it "redirects to root path if user doesnt have the permissions" do
      session[:user_id] = user.id

      post :create, params: { position: { position_name: "tester", user_id: current_user } }

      expect(response).to redirect_to(root_path)
    end
  end

  describe "DELETE #destroy" do
    it "creates a new payment that nullifies the previous one" do
      payment.save!
      user.update(membership_fee_bilance: 10)

      expect(user.payed_fees.length).to eq(1)

      delete :destroy, params: { id: payment.id }
      user.reload
      payment.reload
      expect(user.payed_fees.length).to eq(2)
      expect(user.membership_fee_bilance).to eq(0)
      expect(payment.recalled).to eq(true)

      expect(response).to redirect_to(list_membership_fee_payment_path(user))
    end

    it "returns an error and doesnt do anything if user that created the payment isnt the one deleting it" do
      payment.save!
      user2.save!

      session[:user_id] = user2.id

      delete :destroy, params: { id: payment.id }

      expect(response).to redirect_to(list_membership_fee_payment_path(user))
      expect(flash[:notice]).to eq("Kļūda")
    end

    it "returns an error and doesnt do anything if payment is already recalled" do
      payment.save!
      user2.save!

      payment.update(recalled: true)

      delete :destroy, params: { id: payment.id }

      expect(response).to redirect_to(list_membership_fee_payment_path(user))
      expect(flash[:notice]).to eq("Kļūda")
    end
  end
end
