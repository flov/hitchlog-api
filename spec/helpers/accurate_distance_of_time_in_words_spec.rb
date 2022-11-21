require "rails_helper"

RSpec.describe AccurateDistanceOfTimeInWordsHelper do
  subject do
    helper.accurate_distance_of_time_in_words(seconds)
  end

  context "when seconds is about a minute" do
    let(:seconds) { 80 }

    it "returns the correct string" do
      expect(subject).to eq("1 minute")
    end
  end
  context "when seconds is about 61 minutes" do
    let(:seconds) { 3700 }

    it "returns the correct string" do
      expect(subject).to eq("1 hour and 1 minute")
    end
  end
  context "when seconds is about 1 day 1 hour and 1 minute" do
    let(:seconds) { 90000 }

    it "returns the correct string" do
      expect(subject).to eq("1 day and 1 hour")
    end
  end
end
