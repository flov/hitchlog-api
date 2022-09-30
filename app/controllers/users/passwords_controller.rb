class Users::PasswordsController < Devise::PasswordsController
  # PUT /resource/password
  # Taken from devise gem and overwritten to return json!
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        resource.after_database_authentication
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      render json: {success: true}, status: :ok
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      render json: resource, status: :ok
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end
end
