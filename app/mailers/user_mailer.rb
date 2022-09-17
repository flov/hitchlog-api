class UserMailer < ApplicationMailer
  default from: "noreply@hitchlog.com"

  def welcome_email
    @user = params[:user]
    @url = "http://hitchlog.com/login"
    mail(to: @user.email, subject: "Welcome to Hitchlog")
  end
end
