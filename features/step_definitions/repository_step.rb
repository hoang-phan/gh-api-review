Given(/^there are some repositories on remote server$/) do
  @repositories = JSON(File.read("#{Rails.root}/spec/fixtures/repos.json"))
  $client = double(repositories: @repositories)
end

Then(/^the local repositories should be reloaded$/) do
  @repositories.each do |repo|
    expect(Repository).to be_exists(external_id: repo['id'])
  end
end

When(/^I wait for the fetch repositories worker$/) do
  RepositoriesFetch.drain
end

Given(/^I have the following repositories$/) do |table|
  table.hashes.each do |row|
    Repository.create(full_name: row['Name'], html_url: row['Url'], avatar_url: row['Image Url'])
  end
end

