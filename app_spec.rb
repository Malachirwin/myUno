require "rack/test"
require "rspec"
require "capybara"
require "capybara/rspec"
require "selenium/webdriver"
require "pry"

ENV["RACK_ENV"] = 'test'

require_relative "app"

Capybara.configure do |config|
  config.run_server = false
  config.app_host = "http://localhost:9292"
  config.default_driver = :selenium_chrome_headless
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

RSpec.describe App, type: :feature do
  describe "POST /join", :js do
    it "can submit a name" do
      visit "/"
      expect(page).to have_content "Please enter your name"
      fill_in "name", with: "Malachi"
      click_button "join"
      expect(page).to have_content "Malachi"
    end

    it "play a round when you draw a card" do
      visit "/"
      expect(page).to have_content "Please enter your name"
      fill_in "name", with: "Malachi"
      click_button "join"
      expect(page).to have_content "Malachi"
      card = find(".draw-card", match: :first)
      card.click
      expect(page.all(".player_card").count).to be >= 6 # they start with 5 cards so they should have 6 or more
    end
  end
end
