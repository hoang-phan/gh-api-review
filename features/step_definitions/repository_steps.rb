Given(/^there are some repositories on remote server$/) do
  @repositories = JSON(File.read("#{Rails.root}/spec/fixtures/repos.json"))
  $client = double(organization_repositories: @repositories)
end

Then(/^the local repositories should be reloaded$/) do
  @repositories.each do |repo|
    expect(Repository).to be_exists(full_name: repo['full_name'])
  end
end

When(/^I wait for the fetch repositories worker$/) do
  RepositoriesFetch.drain
end

Given(/^I have the following repositories$/) do |table|
  table.hashes.each do |row|
    Repository.create(full_name: row['Name'])
  end
end

Given(/^I have the repository '(.*)'$/) do |repo|
  create(:repository, full_name: repo)
end

Given(/^the repository '(.*)' has the following branches$/) do |repo, table|
  repository = Repository.find_by(full_name: repo)
  table.hashes.each do |row|
    repository.branches.create(name: row['Name'])
  end
end





