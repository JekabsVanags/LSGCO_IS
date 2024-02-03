require "rails_helper"

RSpec.describe ReportsController, type: :controller do
  !let(:unit) { create(:unit, created_at: Date.today - 380, membership_fee: 2) }
  !let(:unit2) { create(:unit, created_at: Date.today - 380, membership_fee: 2) }
  !let(:unit3) { create(:unit, number: 0, membership_fee: 1) }
  !let(:unit4) { create(:unit, membership_fee: 1, deleted_at: Date.today) }
  !let(:user) { create(:user, joined_date: Date.today - 380, unit: unit, activity_statuss: "Vadītājs", permission_level: "pklv_vaditajs") }
  !let(:user2) { create(:user, joined_date: Date.today, unit: unit, activity_statuss: "Aktīvs", permission_level: "pklv_valde") }
  !let(:user3) { create(:user, unit: unit, activity_statuss: "Izstājies") }
  !let(:weekly_activitity) { create(:weekly_activity, unit: unit) }
  !let(:weekly_activitity2) { create(:weekly_activity, unit: unit) }
  !let(:event) { create(:event, unit: unit) }
  !let(:event2) { create(:event, unit: unit2) }
  !let(:invite) { create(:invite, unit: unit, event: event2, rank: "SK/G") }
  !let(:position) { create(:position, user: user, unit: unit) }
  !let(:payment) { create(:membership_fee_payment, user_payed: user, user_recorded: user, unit: unit, amount: 6, org_fee: 1, date: Date.new(Date.today.year, 1, 12)) }
  !let(:payment2) { create(:membership_fee_payment, user_payed: user, user_recorded: user, amount: 12, org_fee: 1, unit: unit, date: Date.new(Date.today.year, 12, 12)) }
  !let(:payment3) { create(:membership_fee_payment, user_payed: user2, user_recorded: user, amount: 12, org_fee: 1, unit: unit, date: Date.new(Date.today.year, 2, 12)) }
  !let(:rank) { create(:rank_history, user: user, rank: "SK/G", date_of_oath: Date.today, current: true) }
  !let(:rank2) { create(:rank_history, user: user, rank: "MZSK/GNT", date_of_oath: Date.today) }
  !let(:rank3) { create(:rank_history, user: user2, rank: "DZSK/DZG", date_of_oath: nil, current: true) }

  before do
    unit.save!
    unit2.save!
    unit3.save!
    unit4.save!
    user.save!
    user2.save!
    user3.save!
    session[:user_id] = user.id
  end

  describe "GET #unit_report" do
    context "with unit_id" do
      it "fetches data for the specified unit renders the report view" do
        weekly_activitity.save!
        weekly_activitity2.save!
        event.save!
        event2.save!
        invite.save!
        position.save!

        get :unit_report, params: { id: unit.id }
        expect(assigns(:unit)).to eq(unit)
        expect(assigns(:weekly_activities)).to match_array([weekly_activitity, weekly_activitity2])
        expect(assigns(:users)).to match_array([user, user2, user3])
        expect(assigns(:events)).to match_array([event, event2])
        expect(assigns(:positions)).to match_array([position])
        expect(response).to render_template(:unit_report)
      end

      it "creates accurate membership fee report" do
        payment.save!
        payment2.save!
        payment3.save!
        user2.update(membership_fee_bilance: -6)
        get :unit_report, params: { id: unit.id }
        expect(assigns(:payments)).to match_array([{ id: user.id, name: user.name, surname: user.surname, bilance: 0.0, summary: [6.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 12.0] },
                                                   { id: user2.id, name: user2.name, surname: user2.surname, bilance: -6.0, summary: [0.0, 12.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] },
                                                   { id: user3.id, name: user3.name, surname: user3.surname, bilance: 0.0, summary: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] }])
        expect(assigns(:org_fee)).to eq(3)
      end
    end

    context "without unit_id" do
      it "fetches a list of units for selection and renders the report view" do
        get :unit_report
        expect(assigns(:units)).to match_array(Unit.where(deleted_at: nil).where.not(number: 0).map { |unit| [unit.full_name, unit.id] })
        expect(response).to render_template(:unit_report)
      end
    end
  end

  describe "GET #member_report" do
    it "doesnt render report without permission level" do
      get :member_report
      expect(response).to redirect_to(root_path)
    end

    it "renders the member report template for admins" do
      session[:user_id] = user2.id
      get :member_report
      expect(response).to render_template(:member_report)
    end

    it "fetches data for member report statistics" do
      rank.save!
      rank2.save!
      rank3.save!

      session[:user_id] = user2.id
      get :member_report
      expect(assigns(:users)).to match_array([user, user2, user3])
      expect(assigns(:member_report)).to eq({
        member_count: 2,
        unit_count: 2,
        inactive_count: 1,
        new_members_count: 1,
        new_unit_count: 1,
      })

      expect(assigns(:rank_report)).to match_array([{ rank: "MZSK/GNT", count: 0, promise: 0 },
                                                    { rank: "SK/G", count: 1, promise: 1 },
                                                    { rank: "DZSK/DZG", count: 1, promise: 0 },
                                                    { rank: "ROV/LG", count: 0, promise: 0 },
                                                    { rank: "VAD", count: 0, promise: 0 },
                                                    { rank: "VIEDSK/VIEDG", count: 0, promise: 0 },
                                                    { rank: "CITS", count: 0, promise: 0 }])
    end
  end
end
