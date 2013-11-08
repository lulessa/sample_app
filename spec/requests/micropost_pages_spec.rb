require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
    
	describe "with reply" do
	  let(:other_user) { FactoryGirl.create(:user) }
	  before { post_reply(other_user) }

	  # Micropost.first gets latest is default scope is created_at DESC
	  specify { expect(user.microposts.first.replies.first.reply_to).to eq other_user.id }
	end
  end
  
  describe "micropost destruction" do
  	before { FactoryGirl.create(:micropost, user: user) }
  	
  	describe "as correct user" do
	  before { visit root_path }
	  
	  it "should delete a micropost" do
	  	expect { click_link "delete" }.to change(Micropost, :count).by(-1)
	  end
	end
  end
end