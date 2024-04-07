require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let(:unit) { create(:unit) }
  let(:unit3) { create(:unit, deleted_at: Date.today) }
  let(:user) { create(:user, unit: unit, permission_level: "pklv_biedrs") }
  let(:user2) { create(:user, unit: unit, permission_level: "pklv_valde") }
  let(:user3) { create(:user, unit: unit3, permission_level: "pklv_valde") }
  let(:current_user) { create(:user, unit: unit, permission_level: "pklv_valde") }
  let(:rank) { create(:rank_history, user: current_user, rank: "SK/G", current: true) }
  let(:rank2) { create(:rank_history, user: user, rank: "ROV/LG", current: true) }


  before do
    current_user.save!
    session[:user_id] = current_user.id
  end

  describe "GET #new" do
    it "gets a new user instance and renders the template" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    it "creates a new user with associated rank history and redirect" do
      expect do
        post :create, params: { user: { name: "John", surname: "Doe", rank: "SK/G", email: "test@test", activity_statuss: "Aktīvs", joined_date: Date.today } }
      end.to change(User, :count).by(1)

      user = User.last
      expect(user.unit).to eq(current_user.unit)
      expect(user.rank_histories.last.rank).to eq("SK/G")
      expect(response).to redirect_to(root_path)
    end

    it "redirects to root_path on unsuccessful creation" do
      post :create, params: { user: { name: "", surname: "", rank: "" } }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Kļūda")
    end

    it "cannot create if unit is inactive" do
      unit3.save!
      session[:user_id] = user3.id

      post :create, params: { user: { name: "John", surname: "Doe", rank: "SK/G", email: "test@test", activity_statuss: "Aktīvs", joined_date: Date.today } }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Vienība neaktīva")
    end
  end

  describe "GET #edit" do
    it "gets the user to be edited, can set new_user flag to tell that user is new" do
      user_to_edit = create(:user, unit: unit)
      session[:new_user] = true
      get :edit, params: { id: user_to_edit.id }
      expect(assigns(:user)).to eq(user_to_edit)
      expect(assigns(:new_user)).to be(true)
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    it "updates the user and redirects to root" do
      user_to_edit = create(:user, unit: unit)
      new_attributes = { name: "Updated", surname: "User", email: "updated@example.com" }

      patch :update, params: { id: user_to_edit.id, user: new_attributes }
      user_to_edit.reload
      expect(user_to_edit.name).to eq("Updated")
      expect(user_to_edit.surname).to eq("User")
      expect(user_to_edit.email).to eq("updated@example.com")
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Dati atjaunoti")
    end

    it "redirects to root_path on unsuccessful update" do
      user_to_edit = create(:user, unit: unit)
      patch :update, params: { id: user_to_edit.id, user: { name: "", surname: "", email: "" } }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Kļūda")
    end
  end

  describe "DELETE #destroy" do
    it "marks the user as inactive" do
      user_to_delete = create(:user, unit: unit)
      personal_info = create(:personal_information, user: user_to_delete)
      user_to_delete.save!
      delete :destroy, params: { id: user_to_delete.id }
      expect(User.find(user_to_delete.id).activity_statuss).to eq("Izstājies")
      expect(response).to redirect_to(unit_path(user.unit))
    end
  end

  describe "GET #profile" do
    it "gets the current user and associated upcoming events and render profile" do
      event = create(:event, unit: unit, date_from: Date.today + 3)
      event2 = create(:event, unit: unit, date_from: Date.today - 3)
      invite = create(:invite, event: event, unit: unit, rank: "SK/G")
      rank.save!

      get :profile
      expect(assigns(:new_user)).to eq(session[:new_user])
      expect(assigns(:user)).to eq(current_user)
      expect(assigns(:events)).to include(event)
      expect(assigns(:events)).not_to include(event2)

      expect(response).to render_template(:profile)
    end
  end

  describe "POST #unit_update" do
    it "updates the users unit and redirects" do
      new_unit = create(:unit)
      patch :unit_update, params: { id: user.id, unit_id: new_unit.id }
      user.reload
      expect(user.unit).to eq(new_unit)
      expect(response).to redirect_to(user_path(user))
    end

    it "updates the users activity status and redirects" do
      session[:user_id] = current_user.id
      patch :unit_update, params: { id: user.id, activity_statuss: "Interesents" }
      user.reload
      expect(user.activity_statuss).to eq("Interesents")
      expect(response).to redirect_to(user_path(user))
    end
  end

  describe "PATCH #password_update" do
    it "updates the users password" do
      user.password = "test"
      user.save!
      old_password = "test"
      new_password = "new_password"

      patch :password_update, params: { id: user.id, old_password: old_password, password_digest: new_password, repeat_password: new_password }
      user.reload
      expect(user.authenticate(new_password)).to eq(user)
      expect(response).to redirect_to(edit_user_path(current_user))
    end

    it "redirects to root_path on unsuccessful password update for new users" do
      session[:new_user] = true
      patch :password_update, params: { id: user.id, old_password: "wrong_password", password_digest: "new_password", repeat_password: "new_password" }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Nepareiza parole")
    end

    it "redirects to edit_user_path on unsuccessful password update for existing users with notice" do
      patch :password_update, params: { id: user.id, old_password: "wrong_password", password_digest: "new_password", repeat_password: "new_password" }
      expect(response).to redirect_to(edit_user_path(current_user))
      expect(flash[:notice]).to eq("Nepareiza pašreizējā parole")
    end

    it "redirects to aktivizet_path with a notice if passwords do not match and user is new" do
      user.password = "test"
      user.save!
      old_password = "test"
      session[:new_user] = true
      patch :password_update, params: { id: user.id, old_password: old_password, password_digest: "new_password", repeat_password: "different_password" }
      expect(response).to redirect_to(aktivizet_path(user.id, old_password))
    end

    it "redirects to user_edit_path with a notice if passwords do not match" do
      user.password = "test"
      user.save!
      old_password = "test"
      session[:new_user] = false
      patch :password_update, params: { id: user.id, old_password: old_password, password_digest: "new_password", repeat_password: "different_password" }
      expect(response).to redirect_to(edit_user_path(user.id))
    end
  end

  describe "POST #send_password_reset" do
    it "sends a password reset email" do
      ActiveJob::Base.queue_adapter = :test
      user.save!

      post :send_password_reset, params: { id: user.id }

      expect(response).to redirect_to(user_path(user))
      expect(flash[:notice]).to eq("Epasts ar paroles atjaunošanas instrukcijām nosūtīts")

      expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq(1)
      ActiveJob::Base.queue_adapter.enqueued_jobs.clear
    end
  end

  describe "POST #resignation" do
    it "sends an email to unit leader and deletes personal information" do
      post :resignation, params: { id: current_user.id }

      expect(response).to redirect_to(edit_user_path(current_user))
      expect(flash[:notice]).to eq("Jūsu iesniegums ir nosūtīts")

      expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq(1)
      expect(PersonalInformation.where(user: current_user)).to be_empty
      ActiveJob::Base.queue_adapter.enqueued_jobs.clear
    end
  end

  describe "POST #empower_user" do
    it "empowers member to unit manager" do
      current_user.permission_level = "pklv_vaditajs"
      current_user.leader_for_unit = unit
      current_user.save!
      rank2.save!

      expect(user.permission_level).to eq("pklv_biedrs")

      post :empower_user, params: { id: user.id, permission: "pklv_vaditajs" }

      expect(response).to redirect_to(user_path(user.id))
      expect(flash[:notice]).to eq("Piekļuve piešķirta")

      user.reload

      expect(user.permission_level).to eq("pklv_vaditajs")
    end

    it "empowers member to board member" do
      rank2.save!
      expect(user.permission_level).to eq("pklv_biedrs")

      post :empower_user, params: { id: user.id, permission: "pklv_valde" }

      expect(response).to redirect_to(user_path(user.id))
      expect(flash[:notice]).to eq("Piekļuve piešķirta")

      user.reload

      expect(user.permission_level).to eq("pklv_valde")
    end

    it "throws error if current user doesnt have permissions (unit)" do
      rank2.save!
      post :empower_user, params: { id: user.id, permission: "pklv_vaditajs" }

      expect(response).to redirect_to(user_path(user.id))
      expect(flash[:alert]).to eq("Trūkst piekļuves")

      user.reload

      expect(user.permission_level).to eq("pklv_biedrs")
    end

    it "throws error if current user doesnt have permissions (board)" do
      rank2.save!
      current_user.permission_level = "pklv_vaditajs"
      current_user.save!

      post :empower_user, params: { id: user.id, permission: "pklv_valde" }

      expect(response).to redirect_to(user_path(user.id))
      expect(flash[:alert]).to eq("Trūkst piekļuves")

      user.reload

      expect(user.permission_level).to eq("pklv_biedrs")
    end

    it "throws error if current user isnt 16+" do
      current_user.permission_level = "pklv_vaditajs"
      current_user.save!

      post :empower_user, params: { id: user.id, permission: "pklv_valde" }

      expect(response).to redirect_to(user_path(user.id))
      expect(flash[:alert]).to eq("Trūkst piekļuves")

      user.reload

      expect(user.permission_level).to eq("pklv_biedrs")
    end
  end

  describe "POST #depower_user" do
    it "revokes permissions to member" do
      post :depower_user, params: { id: user2.id }

      expect(response).to redirect_to(user_path(user2.id))
      expect(flash[:alert]).to eq("Piekļuve samazināta")

      user2.reload

      expect(user2.permission_level).to eq("pklv_biedrs")
    end

    it "revokes permissions till unit leader if user is unit leader" do
      user2.leader_for_unit = unit
      user2.save!


      post :depower_user, params: { id: user2.id }

      expect(response).to redirect_to(user_path(user2.id))
      expect(flash[:alert]).to eq("Piekļuve samazināta")

      user2.reload

      expect(user2.permission_level).to eq("pklv_vaditajs")
    end
 end
end
