require 'rails_helper'

describe Api::V1::OauthsController, type: :controller do

  before do
    set_json_format
    url = 'https://graph.facebook.com/me?fields=id,email,name&access_token=banana'
    #response_body =  "{\"status\":[{\"id\":\"1\"}]}"
    response_body =  "{\"status\":[200], \"email\":\"test@fromfacebook.com\",
                      \"uid\":\"123123\", \"name\":\"Facebook user\",
                      \"gender\": \"male\", \"birthday\": \"7-7-2014\"}"
    method = :get
    stub_request_url url, {}, method, response_body, true
  end

  let (:facebook_login) { post :create, oauth: {
                            provider: 'facebook',
                            token: 'banana'
                      }}

  describe 'Create action' do
    it 'should create a new user' do
      expect { facebook_login }.to change { User.count }.by(1)
    end

    it 'should create a new oauth for facebook' do
      expect { facebook_login }.to change { Oauth.count }.by(1)
      expect(Oauth.last.provider).to eq 'facebook'
    end

    it 'should just login if user already exists' do
      facebook_login
      expect { facebook_login }.to change { User.count }.by(0)
    end

    it 'should not create new user, provider is wrong' do
      post :create,
        oauth: { provider: 'twitter', token: 'banana' }

      expect(json['error']['message']
        ).to eq 'Provider only facebook and google permitted'
    end
  end
end
