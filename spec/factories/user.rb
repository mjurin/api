FactoryGirl.define do
  factory :user do
    firstname 'John'
    lastname 'Smith'
    email {"user_#{rand(100000).to_s}@heartbeat.com" }
    password 'hardpassword'
    password_confirmation 'hardpassword'
    api_key 'freakinglongapikey'
  end
end
