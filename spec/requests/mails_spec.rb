require "rails_helper"

describe "/mails" do
  describe "POST /contact_form" do
    it "sends an email" do
      post "/mails/contact_form",
        params: {
          contact_form: {
            name: "Florian",
            email: "example@xyz.com",
            message: "Hello"
          }
        }, headers: headers, as: :json

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.last.subject).to eq(
        "[Hitchlog] Contact form message from Florian"
      )
      expect(ActionMailer::Base.deliveries.last.body).to include("Hello")
      expect(ActionMailer::Base.deliveries.last.body).to include("example@xyz.com")
      expect(ActionMailer::Base.deliveries.last.to).to eq(["florian.vallen@gmail.com"])
    end
  end
end
