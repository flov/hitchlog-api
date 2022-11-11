class UserMailer < ApplicationMailer
  default from: "noreply@hitchlog.com"

  def welcome_email
    @user = params[:user]
    @url = "http://hitchlog.com/login"
    mail(to: @user.email, subject: "Welcome to Hitchlog")
  end

  def send_message(from_user, to_user, message)
    @message, @to_user, @from_user = message, to_user, from_user

    mail(
      to: to_user.email,
      subject: "[Hitchlog] Message from user #{from_user.username.capitalize}"
    )
  end

  def contact_form(message, name, email)
    @message, @name, @email = message, name, email
    mail(
      to: "florian.vallen@gmail.com",
      subject: "[Hitchlog] Contact form message from #{@name}"
    )
  end
end
