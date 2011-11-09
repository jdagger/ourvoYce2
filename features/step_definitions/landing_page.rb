When /^I visit the landing page$/ do
  @landing_page = LandingPage.new(Capybara.current_session)
  @landing_page.visit
end
