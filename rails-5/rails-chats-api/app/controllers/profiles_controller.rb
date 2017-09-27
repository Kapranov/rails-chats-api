class ProfilesController < AuthenticationController
  skip_before_action :authenticate, only: [:show, :update, :destroy], raise: false
  before_action :set_profile, only: [:show, :update, :destroy]

  def show
    if @current_user
      render json: @current_user
    else
      render_unauthorized("Error with your login or password")
    end
  end

  def update
    if @current_user.update(profile_params)
      render json: @current_user
    else
      render_unauthorized("Error with your login or password")
    end
  end

  def destroy
    if @current_user.destroy
      render json: { message: "Your user account was deleted" }.to_json, status: :ok
    else
      render_unauthorized("Error with your login or password")
    end
  end

  private

  def set_profile
    @current_user = User.includes(:auth_token).find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(
      :email,
      :password,
      :password_confirmation
    )
  end
end
