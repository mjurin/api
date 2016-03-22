class Oauth < ActiveRecord::Base
  belongs_to :user

  def self.url_for_provider provider
    url = "https://graph.facebook.com/me?fields=id,email,name&access_token="
    url = "https://www.googleapis.com/oauth2/v2/userinfo?access_token=" if provider == "google"
    url
  end

end
