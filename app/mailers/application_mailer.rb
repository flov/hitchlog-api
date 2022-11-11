class ApplicationMailer < ActionMailer::Base
  default from: "noreply@hitchlog.com"
  layout "mailer"

  after_action :create_notification

  def create_notification
    Notification.create(
      issued_by: params ? params[:user] : nil,
      mailer: self.class.name,
      mailer_method: action_name,
      from: mail.from.first,
      to: mail.to.first,
      subject: mail.subject,
      body: mail.body.to_s
    )
  end
end
