Given(/^there are some repositories on remote server$/) do
  @repositories = JSON(File.read("#{Rails.root}/spec/fixtures/repos.json"))
  $client = double
  allow($client).to receive(:org_repos).with(GITHUB_ENV['owner_name'], page: 1, per_page: GITHUB_ENV['results_per_page']).and_return(@repositories)
  allow($client).to receive(:org_repos).with(GITHUB_ENV['owner_name'], page: 2, per_page: GITHUB_ENV['results_per_page'])
end

Then(/^the local repositories should be reloaded$/) do
  @repositories.each do |repo|
    expect(Repository).to be_exists(full_name: repo['full_name'])
  end
end

Given(/^I have the following repositories$/) do |table|
  Repository.import(table.hashes.map do |row|
    Repository.new(full_name: row['Name'])
  end)
end

Given(/^I have the (unwatched |watched )?repository '(.*)'$/) do |status, repo|
  create(:repository, full_name: repo, watched: status == 'watched ')
end

Given(/^the repository '(.*)' has the following branches$/) do |repo, table|
  repository = Repository.find_by(full_name: repo)
  Branch.import(table.hashes.map do |row|
    repository.branches.build(name: row['Name'], watched: row['Watched'])
  end)
end

When(/^I (?:watch|unwatch) the repository '(.*)'$/) do |repo|
  find('.repository-item', text: repo).find('.bootstrap-switch').click
end

Then(/^the repository '(.*)' should be (watched|unwatched)$/) do |repo, status|
  expect(Repository.find_by(full_name: repo).watched).to eq (status == 'watched')
end







