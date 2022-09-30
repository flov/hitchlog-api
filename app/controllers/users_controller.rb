class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[me create update destroy]
  before_action :set_user, only: %i[show profile destroy]

  # GET /users.json
  def index
    @page = params[:page] || 1
    @users = User.order(created_at: :desc).page(@page)
  end

  def profile
    render json: {error: "user not found"} if !@user
  end

  # GET /users/1.json
  def show
    if @user
      render :show, status: :ok, location: @user
    else
      render json: {error: "user not found"}
    end
  end

  # GET /users/me.json
  def me
    @user = current_user
    render :show, location: @user
  end

  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1.json
  def destroy
    @user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = if params[:username]
      User.find_by_username(params[:id])
    else
      User.find_by_id(params[:id])
    end
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.fetch(:user, {})
  end
end
