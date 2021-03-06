require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
	let(:user) { FactoryGirl.create(:user) }
    before(:each) do
	  sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do
    
	  before(:all)	{ 30.times { FactoryGirl.create(:user) } }
	  after(:all)	{ User.delete_all }
	  
	  it { should have_selector("div.pagination") }
	  
	  it "should list each user" do
		User.paginate(page: 1).each do |user|
		  expect(page).to have_selector('li', text: user.name)
		end
	  end
	end
	
	describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
	let(:other_user) { FactoryGirl.create(:user) }

	before do
	  sign_in other_user
	  visit user_path(user)
	end

	it { should have_content(user.name) }
	it { should have_title(user.name) }
	it { should have_content(user.username) }
	
	describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
      
      describe "delete links should not appear for other user" do
		it { should_not have_link('delete') }
      end
    end
    
    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_xpath("//input[@value='Unfollow']") }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_xpath("//input[@value='Follow']") }
        end
      end
    end
  end

  describe "Signup page" do
    before { visit signup_path }
    let(:heading) { 'Sign Up' }
    let(:page_title) { heading }

    it { should have_content(heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

	  describe "after submission" do
        before { click_button submit }
        let(:page_title) { 'Sign Up' }
        error_list = ["Name can't be blank", "Email can't be blank",
					  "Email is invalid", "Username can't be blank",
					  "Username is invalid", "Password can't be blank"]

        it { should have_title(full_title(page_title)) }
        it { should have_content('error') }
        error_list.each do |error_message|
        	it { should have_content(error_message) }
        end
      end
    end

    describe "with valid information" do
	  let(:user_email) { "user@example.com" }
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Username",     with: "exampleuser"
        fill_in "Email",        with: user_email
        fill_in "Password",     with: "foobar"
        fill_in "Confirm Password", with: "foobar"
        check	"user_follower_notification"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

#	  describe "delivers signup confirmation message to user" do
#		last_email.should_not be_nil
#		last_email.to.should == user_email
#		last_email.subject.should include("confirm")
#	  end

	  describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: user_email) }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_success_message('Welcome') }
      end
    end
  end

  describe "edit" do
  	let(:user) { FactoryGirl.create(:user) }
  	before do
	  sign_in user
	  visit edit_user_path(user)
  	end

    let(:save_changes) { "Save changes" }
  	
  	describe "page" do
	  it { should have_content("Update your profile") }
	  it { should have_title("Edit user") }
	  it { should have_link("change", href: "http://gravatar.com/emails") }
  	end
  	
  	describe "with valid information and blank password" do
	  let(:new_name)  { "New Name" }
	  let(:new_username)  { "NewName" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
		fill_in "Username",         with: new_username
        fill_in "Email",            with: new_email
        uncheck	"user_follower_notification"
        click_button save_changes
      end

      it { should have_title(new_name) }
      it { should have_success_message('updated') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.username).to  eq new_username }
      specify { expect(user.reload.email).to eq new_email }
  	end
  	
  	describe "with invalid information (short password)" do
	  before do
		fill_in "Password",         with: "123"
		fill_in "Confirm Password", with: "123"
		click_button save_changes
	  end
	
	  it { should have_error_message('error') }
	  it { should have_content("Password is too short") }
  	end

  	describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end
  
  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_title(full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_title(full_title(other_user.name + ' Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  
	describe "user relationship stats" do
	  before do
	  	other_user.follow!(user)
	  	visit user_path(user)
	  end
	  
	  it { should have_link("1 following", href: following_user_path(user)) }
	  it { should have_link("1 followers", href: followers_user_path(user)) }
	end
  end
end
