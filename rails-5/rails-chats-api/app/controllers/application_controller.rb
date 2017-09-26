class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def authenticate!
    authenticate_token || render_unauthorized("Access denied")
  end

  def current_user
    @current_user ||= authenticate_token
  end

  protected

  def render_unauthorized(message)
    errors = { errors: [ { detail: message } ] }.to_json
    render json: errors, status: :unauthorized
  end

  private

  def authenticate_token
    authenticate_or_request_with_http_token do |token, options|
      User.joins(:auth_token).find_by(auth_tokens: { value: token })
    end
  end
end
