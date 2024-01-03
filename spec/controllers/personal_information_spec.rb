require "rails_helper"

RSpec.describe PersonalInformationController, type: :controller do
  let(:unit) { create(:unit) }
  let(:user) { create(:user, username: "test_user", password: "password", unit: unit) }

  before do
    user.save!
    session[:user_id] = user.id
  end

  describe "GET #new" do
    it "assigns a new personal information instance and renders new template" do
      get :new
      expect(assigns(:info)).to be_a_new(PersonalInformation)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    it "creates a new personal information record and redirects to aptaujas_lapa_path" do
      expect do
        post :create, params: { personal_information: { health_issues: "No", medication_during_event: "No", psychological_features: "No", diet: "Vegetarian" } }
      end.to change(PersonalInformation, :count).by(1)
      expect(response).to redirect_to(aptaujas_lapa_path)
    end

    it "redirects to aptaujas_lapa_path on unsuccessful creation" do
      post :create, params: { personal_information: { health_issues: "", medication_during_event: "", psychological_features: "", diet: "" } }
      expect(response).to redirect_to(aptaujas_lapa_path)
    end
  end

  describe "GET #edit" do
    it "assigns the users personal information and renders the edit template" do
      personal_info = create(:personal_information, user: user)
      get :edit
      expect(assigns(:info)).to eq(personal_info)
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    it "updates the users personal information and redirects" do
      personal_info = create(:personal_information, user: user)
      new_attributes = { health_issues: "No", medication_during_event: "No", psychological_features: "Yes", diet: "Vegan" }

      patch :update, params: { personal_information: new_attributes }
      personal_info.reload
      expect(personal_info.health_issues).to eq("No")
      expect(personal_info.medication_during_event).to eq("No")
      expect(personal_info.psychological_features).to eq("Yes")
      expect(personal_info.diet).to eq("Vegan")

      expect(response).to redirect_to(aptaujas_lapa_path)
    end

    it "redirects to aptaujas_lapa_path on unsuccessful update" do
      personal_info = create(:personal_information, user: user)
      patch :update, params: { personal_information: { health_issues: "", medication_during_event: "", psychological_features: "", diet: "" } }
      expect(response).to redirect_to(aptaujas_lapa_path)
    end
  end

  describe "DELETE #destroy" do
    it "deletes the users personal information and redirects to aptaujas_lapa_path" do
      personal_info = create(:personal_information, user: user)
      expect do
        delete :destroy
      end.to change(PersonalInformation, :count).by(-1)
      expect(response).to redirect_to(aptaujas_lapa_path)
    end
  end

  describe "GET #show" do
    it "assigns the users personal information and renders the show template" do
      personal_info = create(:personal_information, user: user)
      get :show
      expect(assigns(:info)).to eq(personal_info)
      expect(response).to render_template(:show)
    end
  end
end
