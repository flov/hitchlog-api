class UserMailer < ApplicationMailer
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

  def save_notification
    puts 'save_notification'
  end
end
