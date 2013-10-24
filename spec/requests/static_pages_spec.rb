require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  test_pages = {
  #	home: "Home", # has a custom test
  	help: "Help",
  	about: "About Us",
  	contact: "Contact"
  }

 describe "Home page" do

    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end

    it "should have the base title" do
      visit '/static_pages/home'
      expect(page).to have_title("Ruby on Rails Tutorial Sample App")
    end

    it "should not have a custom page title" do
      visit '/static_pages/home'
      expect(page).not_to have_title('| Home')
    end
  end
  
  test_pages.each { |pg,tt|

	  describe "#{tt}" do

		it "should have the content '#{tt}'" do
		  visit "/static_pages/#{pg}"
		  expect(page).to have_content("#{tt}")
		end
	
		it "should have the title '#{tt}'" do
		  visit "/static_pages/#{pg}"
		  expect(page).to have_title("#{base_title} | #{tt}")
		end

	  end

  } # test_pages.each

end #describe Static pages