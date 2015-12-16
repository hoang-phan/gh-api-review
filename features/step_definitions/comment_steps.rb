Given(/^there are some rules$/) do |table|
  rules = table.hashes.map do |row|
    {
      'regex' => {
        row['lang'] => row['regex']
      },
      'name' => row['name']
    }
  end
  stub_const('LINE_RULES', rules)
end

Given(/^there are some random comments for rules$/) do |table|
  comments = table.hashes.each_with_object({}) do |row, result|
    result[row['rule']] = row['suggestions'].split(',')
  end
  stub_const('RANDOM_COMMENTS', comments)
end

Then(/^I should see dropdown '(.*)' with following options$/) do |field, table|
  expect(page).to have_select(field, table.raw)
end
