require "spec_helper"

describe Notifier do
  describe "follower notification" do
    let(:user) { FactoryGirl.create(:user) }
    let(:follower) { FactoryGirl.create(:user) }
    let(:mail) { Notifier.follower_notification(user,follower) }

    it "send notification message" do
      mail.subject.should eq("#{follower.name} is following you")
      mail.to.should eq([user.email])
      mail.from.should eq(["from@example.com"])
      mail.body.encoded.should match(user_url(follower))
    end
  end
end
