Given(/^I am on the (.*) page$/) do |path|
  visit eval("#{path}_path")
end

When(/^I click on '(.*)'$/) do |clickable|
  click_on clickable
end

Then(/^I should see '(.*)'$/) do |content|
  expect(page).to have_content content
end

Then(/^I should see '(.*)' in '(.*)' field$/) do |content, field|
  expect(page).to have_field(field, with: content)
end

Then(/^I should not see '(.*)' in '(.*)' field$/) do |content, field|
  expect(page).not_to have_field(field, with: content)
end

Then(/^I should see all the following$/) do |table|
  table.hashes.each do |row|
    expect(page).to have_content(row['Content'])
  end
end

Given(/^now is '(.*)'$/) do |time_str|
  Timecop.freeze(time_str)
end

Then(/^I should see link '(.*)' to (.*) page$/) do |link, path|
  expect(page).to have_link(link, href: eval("#{path}_path"))
end

Then(/^I wait for '(.*)' workers to finish$/) do |worker|
  worker.constantize.drain
end

When(/^I fill in '(.*)' with '(.*)'$/) do |field, value|
  fill_in field, with: value
end

When(/^I wait for ajax to finish$/) do
  wait_for_ajax
end

When(/^I focus first field with name '(.*)'$/) do |field|
  @field = first("[name=#{field}]")
end

When(/^I press tab$/) do
  @field.native.send_keys :tab
end

When(/^I enter '(.*)'$/) do |str|
  @field.set(str)
end

Then(/^I should see '(.*)' on '(.*)' field$/) do |content, field|
  expect(page).to have_field(field, with: content)
end

When(/^I select '(.*)' from dropdown '(.*)'$/) do |option, field|
  select option, from: field
end

Then(/^no ajax call should be made$/) do
  expect(finished_all_ajax_requests?).to be_truthy
end
