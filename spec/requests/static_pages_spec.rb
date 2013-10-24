require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  test_pages = {
  	home: "Home",
  	help: "Help",
  	about: "About Us",
  	contact: "Contact"
  }
  
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