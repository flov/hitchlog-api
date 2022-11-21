require "rails_helper"

RSpec.describe Notification, type: :model do
  describe "validations" do
    subject { Notification.new }

    it "is valid with valid attributes" do
      subject.valid?
      expect(subject).to_not be_valid
      [:mailer, :mailer_method, :to, :subject, :body].each do |attr|
        # expect model to have error on attributes
        expect(subject.errors[attr]).to_not be_empty
      end
    end
  end
end
