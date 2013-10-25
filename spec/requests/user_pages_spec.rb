require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "Signup page" do
    before { visit signup_path }
    let(:heading) { 'Sign Up' }
    let(:page_title) { heading }

    it { should have_content(heading) }
    it { should have_title(full_title(page_title)) }
  end
end