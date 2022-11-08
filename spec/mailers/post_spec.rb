require "rails_helper"

RSpec.describe PostMailer, type: :mailer do
  describe "#notify_post_author" do
    it "renders template" do
      @post = FactoryBot.create(:post)
      expect { PostMailer.notify_post_author(@post) }.not_to raise_error
    end
  end
end
