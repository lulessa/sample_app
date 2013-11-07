require 'spec_helper'

describe Reply do
  let(:user) { FactoryGirl.create(:user) }
  let(:micropost) { FactoryGirl.create(:micropost) }
  let(:other_user) { FactoryGirl.create(:user) }
  before { @reply = micropost.replies.build(reply_to: other_user.id) }

  subject { @reply }

  it { should respond_to(:micropost_id) }
  it { should respond_to(:reply_to) }
  it { should respond_to(:micropost) }
  its(:micropost) { should eq micropost }
  
  it { should be_valid }

  describe "when micropost_id is not present" do
    before { @reply.micropost_id = nil }
    it { should_not be_valid }
  end
  
  describe "reply_to directed at nobody" do
  	before { @reply.reply_to = nil }
    it { should_not be_valid }  	
  end
end
