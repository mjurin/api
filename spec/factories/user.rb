FactoryGirl.define do
  factory :user do
    email {"user_#{rand(1000).to_s}@heartbeat.com" }
    password 'hardpassword'
    password_confirmation 'hardpassword'
    api_key 'freakinglongapikey'
  end
end
