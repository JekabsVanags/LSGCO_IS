require 'rails_helper'

RSpec.describe SessionController, type: :controller do
  describe 'POST #create' do
    context 'with valid username and password' do
      let(:unit) { create(:unit) }
      let(:user) { create(:user, username: 'test_user', password: 'password', unit: unit) }

      it 'creates a session and redirects to profile' do
        user.save!
        post :create, params: { username: 'test_user', password: 'password' }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(profils_path)
      end
    end

    context 'with invalid username or password' do
      it 'redirects to the root path with an alert' do
        post :create, params: { username: 'invalid_user', password: 'invalid_password' }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'GET #destroy' do
    let(:unit) { create(:unit) }
    let(:user) { create(:user, username: 'test_user', password: 'password', unit: unit) }


    it 'clears the session and redirects to root path' do
      user.save!
      session[:user_id] = user.id
      get :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'POST #first_login' do
      let(:unit) { create(:unit) }
      let(:user_valid) { create(:user, username: 'test_user', password: 'password', unit: unit, created_at: Date.today, updated_at: Date.today) }
      let(:user_late) { create(:user, username: 'test_user', password: 'password', unit: unit, created_at: Date.today-200, updated_at: Date.today-200) }


    it 'sets the user in the session doesnt redirect' do
      user_valid.save!
      post :first_login, params: { id: user_valid.id, password: 'password' }
      expect(session[:user_id]).to eq(user_valid.id)
      expect(response).not_to redirect_to(root_path)
    end

    it 'does not set the user in the session if conditions are not met' do
      user_late.save!
      post :first_login, params: { id: user_late.id, password: 'password' }
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end
