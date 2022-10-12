class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(_resource, _opts = {})
    render json: {
      message: "Signed in successfully",
      user: {
        id: current_user.id,
        email: current_user.email,
        username: current_user.username,
        md5_email: current_user.md5_email,
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    log_out_success && return if current_user

    log_out_failure
  end

  def log_out_success
    render json: {message: "you are logged out."}, status: :ok
  end

  def log_out_failure
    render json: {error: "Hmm nothing happened"}, status: :unauthorized
  end
end
