class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[me create update destroy send_message]
  before_action :set_user, only: %i[geomap show update profile destroy]
  before_action :user_owner?, only: %i[update destroy]

  # GET /users.json
  def index
    @page = params[:page] || 1
    @users = User
      .includes(:trips)
      .ransack(trips_from_name_present: true)
      .result(distinct: true)
      .order(created_at: :desc)
      .page(@page)
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
    return render json: {error: "user not found"}, status: :not_found if !@user
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

  # GET /users/1/geomap.json
  def geomap
  end

  # POST /users/1/send_message
  def send_message
    @user = User.find_by_username(params[:id])
    if @user == current_user
      render json: {error: "you can't send a message to yourself"}, status: :unprocessable_entity
    elsif @user
      UserMailer
        .with(user: current_user)
        .send_message(current_user, @user, params[:message])
        .deliver_now
      render json: {message: "sent"}
    else
      render json: {error: "user not found"}, status: :not_found
    end
  end

  def confirm
    @user = User.confirm_by_token(params[:confirmation_token])
    if @user && @user.errors.empty?
      render json: {message: "confirmed"}
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_owner?
    render json: {error: "not authorized"}, status: :unauthorized if @user != current_user
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @user = User.find_by_username(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.fetch(:user, {}).permit(
      :username,
      :email,
      :cs_user,
      :be_welcome_user,
      :trustroots,
      :gender,
      :about_you,
      :languages,
      :city,
      :country,
      :country_code,
      :formatted_address,
      :lat,
      :lng
    )
  end
end
