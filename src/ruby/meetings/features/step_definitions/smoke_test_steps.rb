Given(/^I am on the smoke test page$/) do
  smoke_test.visit_page
end

When(/^I click on the  button$/) do
  smoke_test.page_click_button('Click me')
end

Then(/^I should see an alert message$/) do
  smoke_test.check_an_alert_message('Click me','click target')
end

When(/^I click on the "(.*?)" button$/) do |arg1|
  smoke_test.page_click_button(arg1)
end

When(/^I fill in the modal login$/) do
  smoke_test.fill_in_modal_login(@user_attributes)
end

Then(/^I should be logged in$/) do
#      page.should have_content('Signed in')
  smoke_test.check_logged_in
end

When(/^I go to the home page$/) do
   smoke_test.load
end

Then(/^I should see a navbar$/) do
  expect(smoke_test).to have_navbar
end

Then(/^it should have a home button on the left$/) do
  expect(smoke_test).to have_home_page_link
end

Then(/^it should have flags on the right$/) do
  expect(smoke_test).to have_right_aligned_flags
end

