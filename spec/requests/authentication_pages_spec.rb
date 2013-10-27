require 'spec_helper'

describe "Authentication" do

  subject { page }
  let(:signin_title) { 'Sign in' }
  

  describe "signin page" do
	before { visit signin_path }

    it { should have_content(signin_title) }
    it { should have_title(signin_title) }
  end

  describe "signin" do
    before { visit signin_path }
    let(:signin_button) { signin_title }

    describe "with invalid information" do
      before { click_button signin_button }

      it { should have_title(signin_title) }
      it { should have_error_message('Invalid') }

	  describe "after visiting another page flashes error" do
	  	before { click_link 'Home' }
	  	it { should_not have_error_message('') }
	  end
    end

	describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }

      it { should have_title(user.name) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

	  describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link(signin_title) }
      end
    end
  end
end
