require "rails_helper"

RSpec.describe RideMailer, type: :mailer do
  describe "#notify_about_liked_ride" do
    it "sends an email to the trip owner" do
      @ride = FactoryBot.create(:ride)
      expect { RideMailer.notify_about_liked_ride(@ride) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
