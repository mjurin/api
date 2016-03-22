class Api::V1::OauthsController < ApplicationController
  require 'open-uri'

  def create
    @user = User.new
    provider = oauth_params[:provider]
    if provider =~ /facebook|google/
      url = Oauth.url_for_provider provider

      begin
        content = open(URI.encode(url + oauth_params[:token]))
      rescue OpenURI::HTTPError
        @user.errors.add(:token, t('oauths.wrong_or_expired_access_token'))
        return render_json_object @user
      end

      status  = content.status[0]
      content = JSON.load(content)

      profile_picture = ""
      if provider == "facebook"
        profile_picture = "http://graph.facebook.com/"+content["id"]+"/picture?type=large".to_s unless Rails.env.test?
      elsif "google" == provider
        profile_picture = content['picture']
      end

      email = content['email']
      uid = content['id']

      create_new_user = false

      if status.to_i != 200
        @user.errors.add(:provider, t('oauths.provider_error_after_connection'))
      elsif @oauth = Oauth.find_by_provider_and_uid(provider, uid)
        unless @user = @oauth.user #User was
          create_new_user = true
          @oauth.delete
        end
      elsif @user = User.find_by_lower_email(email).first
        #user exists, create oauth
        Oauth.create( provider: provider, uid: uid, user: @user)
      else #create new user
        create_new_user = true
      end

      if create_new_user
        @user = User.new
        @user.email = email
        @user.profile_picture_url = profile_picture

        @user.password = SecureRandom.urlsafe_base64
        @user.password_confirmation = @user.password

        Oauth.create( provider: provider, uid: uid, user: @user) if @user.save
      end
    else
      @user.errors.add(:provider, t('oauths.only_fb_and_google_permitted'))
    end

    render_json_object @user
  end

  private
    def oauth_params
      params.require(:oauth).permit(
        :provider,
        :token)
    end


end
