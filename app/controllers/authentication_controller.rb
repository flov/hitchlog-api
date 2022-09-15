class AuthenticationController < ApplicationController
  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = jwt_encode({user_id: @user.id})
      response.set_header("Set-Cookie", "token=#{token}")
      render json: {token: token}
    else
      render json: {errors: "Invalid email or password"}, status: :unauthorized
    end
  end
end
