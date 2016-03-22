require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  before do
    set_json_format
    @user = create(:user)
    api_login_as @user
  end

  describe 'Create action' do
    it 'Should create new user if name, email and password are valid' do
      expect {
        post :create, user: { email: 'test@user.com',
                              password: 'testuserhardpassword',
                              password_confirmation: 'testuserhardpassword' }
      }.to change { User.count }.by(1)
    end

    it 'Should return error, password does not match' do
      post :create, user: { email: 'test@user.com',
                            password: 'testuserhardpassword',
                            password_confirmation: 'does not match' }

      expect(json['error']['message']
        ).to eq "Password confirmation doesn't match Password"
    end
  end

  describe 'Update action' do
    it 'expects to update user firstname' do
      put :update, id: @user.id, user: { firstname: 'Updated name' }
      expect(json['firstname']).to eq "Updated name"
    end

    it 'expects not to update user email if not valid' do
      put :update, id: @user.id, user: { email: 'Updated email' }
      expect(json['error']['message']).to eq 'Email is invalid'
    end
  end

  describe 'Index action' do
    it 'expects to get 10 users - should not return current user' do
      FactoryGirl.create_list(:user, 10)

      get :index
      expect(response).to be_success
      expect(json.length).to eq(10)
    end
  end
end
