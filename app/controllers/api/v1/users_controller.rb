class Api::V1::UsersController < ApplicationController
  before_action :require_authentication, except: [ :create ]

  def create
    @user = User.new(user_params.merge(require_password: true,
                                       require_password_confirmation: true))
    @user.save

    render_json_object @user
  end

  def index
    @users = User.all - [current_user]
    render json: @users.to_json
  end

  def user_params
      params.require(:user).permit(
        :email,
        :password,
        :password_confirmation
      )
  end

end
