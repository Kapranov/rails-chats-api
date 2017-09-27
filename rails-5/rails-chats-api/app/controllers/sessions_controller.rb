class SessionsController < AuthenticationController
  skip_before_action :authenticate, only: [:create, :destroy], raise: false

  before_action :set_session,  only: [:destroy]

  def create
    @current_user = User.new(session_params)

    if @current_user.save
      render json: { api_token: @current_user.auth_token.value }.to_json
    else
      render_unauthorized("Error with your login or password")
    end
  end

  def destroy
    if @current_user.destroy
      render json: { message: "User was deleted" }.to_json, status: :ok
    else
      render_unauthorized("Error with your login or password")
    end
  end

  private

  def set_session
    @current_user = User.includes(:auth_token).find(params[:id])
  end

  def auth_token_params
    params.require(:auth_token).permit(:user_id, :value)
  end

  def session_params
    params.require(:session).permit(
      :email,
      :password
    )
  end
end
