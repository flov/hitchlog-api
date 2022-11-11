require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "send_message" do
    let(:current_user) { create(:confirmed_user) }
    let(:user) { create(:confirmed_user) }
    let(:mail) { UserMailer.send_message(current_user, user, "hello") }

    it "renders the headers" do
      expect(mail.subject).to eq("[Hitchlog] Message from user #{current_user.username.capitalize}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@hitchlog.com"])
    end
  end

  describe "contact_form" do
    let(:user) { create(:confirmed_user) }
    let(:name) { "John Doe" }
    let(:email) { "xyz@example.com" }
    let(:mail) { UserMailer.contact_form("example message", name, email) }

    it "renders the headers" do
      expect(mail.subject).to eq("[Hitchlog] Contact form message from John Doe")
      expect(mail.to).to eq(["florian.vallen@gmail.com"])
    end
  end
end
