class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  def require_authentication
    unless current_user
      self.headers['WWW-Authenticate'] = 'Token realm="Application"'
      render json: 'Bad credentials', status: 401
    end
  end

  def current_user
    unless @current_user
      authenticate_with_http_token do |token, options|
        user = User.find_by_api_key(token)
        @current_user = user if user
      end
    end
    @current_user
  end

  def render_json_object object
    if object.errors.any?
      render json: { error: {message: object.errors.full_messages.first }}, status: :bad_request
    else
      render json: object.to_json
    end
  end
end
