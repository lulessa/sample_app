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
  
  describe "password_reset" do
    let(:user) { FactoryGirl.create(:user,
    								:password_reset_token => "anything") }
    let(:mail) { Notifier.password_reset(user) }

    it "sends user password reset url" do
      mail.subject.should eq("Password Reset")
      mail.to.should eq([user.email])
      mail.from.should eq(["from@example.com"])
    end

    it "renders reset token in the email body" do
      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end

  describe "confirm email address" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { Notifier.confirm_email(user) }
    
	it "sends message with confirm link" do
      mail.subject.should eq("Please confirm your email address")
      mail.to.should eq([user.email])
      mail.from.should eq(["from@example.com"])
      mail.body.encoded.should include ( 
      	edit_activate_account_url(id: user.id,
								  token: user.confirm_token)
	  )
	end
  end
end
