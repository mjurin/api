class Api::V1::SessionsController < ApplicationController

  def create
    @user = User.find_by_lower_email(user_params[:email]).first
    if @user
      @user.errors.add(:password, t('globals.wrong_email_or_password')) unless
        @user.authenticate(user_params[:password])
    else
      @user = User.new user_params
      @user.errors.add(:email, t('globals.wrong_email_or_password'))
    end

    render_json_object @user
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end


end

