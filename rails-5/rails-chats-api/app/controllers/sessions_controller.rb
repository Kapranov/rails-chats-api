class SessionsController < ApplicationController
  skip_before_action :authenticate!, only: [:create], raise: false

  def create
    if @current_user = User.valid_login?(params[:email], params[:password])
      render json: { api_token: @current_user.auth_token.value }.to_json
    else
      render_unauthorized("Error with your login or password")
    end
  end

  def destroy
    @current_user.logout
    head :ok
  end
end
