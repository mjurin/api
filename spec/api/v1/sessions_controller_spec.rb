require 'rails_helper'

describe Api::V1::SessionsController, type: :controller do
  before do
    set_json_format
    @user = create :user
  end

  describe 'create session' do
    it 'should return user with api_key' do
      post :create, user: { email: @user.email, password: @user.password }
      expect(json['email']).to eq @user.email
      expect(json['api_key']).not_to eq nil
    end

    it 'should not return user, wrong password' do
      post :create, user: { email: @user.email, password: 'wrong password' }
      expect(json['error']['message']).to eq 'Password or email is wrong'
    end
  end
end
