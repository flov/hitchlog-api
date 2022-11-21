class MailsController < ApplicationController
  # POST /users/contact_form
  def contact_form
    if UserMailer.contact_form(
      contact_form_params[:message],
      contact_form_params[:name],
      contact_form_params[:email]
    ).deliver_now
      render json: {message: "sent"}
    else
      render json: {error: "message not sent"}, status: :unprocessable_entity
    end
  end

  private

  def contact_form_params
    params.fetch(:contact_form, {}).permit(:email, :message, :name)
  end
end
