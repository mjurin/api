Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
end

unless Rails.env.production?
  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:facebook, {
    "uid"       => '1234501',
     "info" => {
        "email" => "john.doe.test@ulu.io",
        "first_name" => "John",
        "last_name"  => "Doe",
        "name"       => "John Doe"
        # "picture"=> "https://www.drupal.org/files/project-images/vine-url.png"
        # any other attributes you want to stub out for testing
     }
    })
end
