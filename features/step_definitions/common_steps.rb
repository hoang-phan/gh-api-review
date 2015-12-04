Given(/^I am on the (.*) page$/) do |path|
  visit eval("#{path}_path")
end

When(/^I click on '(.*)'$/) do |clickable|
  click_on clickable
end

Then(/^I should see '(.*)'$/) do |content|
  expect(page).to have_content content
end

Then(/^I should see all the following$/) do |table|
  table.hashes.each do |row|
    expect(page).to have_content(row['Content'])
  end
end