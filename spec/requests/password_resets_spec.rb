require 'spec_helper'

describe "PasswordResets" do

  subject { page }
  let(:forgot_link) { "Forgot your password?" }
  let(:reset) { "Reset Password" }
  let(:change) { "Change Password" }

  it "emails user when requesting password reset" do
    user = FactoryGirl.create(:user)
    visit signin_path
    click_link forgot_link
    fill_in "Email", :with => user.email
    click_button reset
#    current_path.should eq(root_path)
    page.should have_content("Email sent")
    last_email.to.should include(user.email)
  end

  it "does not email invalid user when requesting password reset" do
    user = FactoryGirl.create(:user)
    visit signin_path
    click_link forgot_link
    fill_in "Email", :with => "notarealuser@example.com"
    click_button reset
    page.should_not have_content("Email sent")
    last_email.should be_nil
  end
  
  describe "updates the user password when confirmation matches" do
  	before do
	  user = FactoryGirl.create(:user, :password_reset_token => "something", 
									   :password_reset_sent_at => 1.hour.ago)
	  visit edit_password_reset_path(user.password_reset_token)
	end
  	
  	describe "with blank password" do
	  before { click_button change }

	  it { should have_content("Password can't be blank") }
  	end
  	
  	describe "with short password and without matching password confirmation" do
	  before do
		fill_in "Password", with: "12"
		click_button change
	  end

	  it { should have_content("Password is too short") }
	  it { should have_content("Password confirmation doesn't match") }
	end

	describe "with valid new password and confirmation" do
	  before do
		fill_in "Password", with: "foobarR1!"
		fill_in "Confirm Password", with: "foobarR1!"
		click_button change
	  end

	  it { should have_content("Your password has been reset") }
	end
  end

  it "reports when password token has expired" do
    user = FactoryGirl.create(:user, :password_reset_token => "something", 
							  :password_reset_sent_at => 5.hour.ago)
    visit edit_password_reset_path(user.password_reset_token)
    page.should have_content("Password reset link has expired")
  end

  it "raises record not found when password token is invalid" do
    lambda {
      visit edit_password_reset_path("invalid")
    }.should raise_exception(ActiveRecord::RecordNotFound)
  end
end
