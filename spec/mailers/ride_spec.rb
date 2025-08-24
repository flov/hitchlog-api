require "rails_helper"

RSpec.describe RideMailer, type: :mailer do
  describe "notify_about_liked_ride" do
    let(:ride) { create(:ride) }
    let(:mail) { RideMailer.notify_about_liked_ride(ride) }

    it "renders the headers" do
      expect(mail.subject).to eq("[Hitchlog] Someone liked your ride!")
      expect(mail.to).to eq([ride.trip.user.email])
      expect(mail.from).to eq(["noreply@hitchlog.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end
