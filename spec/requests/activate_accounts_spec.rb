require 'spec_helper'

describe "Activate Account" do

  subject { page }
  
  describe "activates user when email confirm_token matches" do
  	before do
	  user = FactoryGirl.create(:user)
	  visit edit_activate_account_url(id: user.id,
									  token: user.confirm_token)
	end

	it { should have_content("confirmed") }
  end

  it "raises record not found when confirm_token is invalid" do
    lambda {
      visit url_for(controller: "activate_accounts",
					action: "edit",
					id: 0,
					token: "invalid")
    }.should raise_exception(ActiveRecord::RecordNotFound)
  end
end
