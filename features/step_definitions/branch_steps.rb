Given(/^there are some branches of repository on remote server$/) do
  @branches = JSON(File.read("#{Rails.root}/spec/fixtures/branches.json"))
  $client = double
  allow($client).to receive(:branches).with(anything, page: 1, per_page: GITHUB_ENV['results_per_page']).and_return(@branches)
  allow($client).to receive(:branches).with(anything, page: 2, per_page: GITHUB_ENV['results_per_page'])
end

Then(/^the local branches of repository '(.*)' should be reloaded$/) do |repo|
  repository = Repository.find_by(full_name: repo)
  @branches.each do |branch|
    expect(repository.branches).to be_exists(name: branch['name'])
  end
end

When(/^I (?:watch|unwatch) the branch '(.*)'$/) do |branch|
  find('.branch-item', text: branch).find('.bootstrap-switch').click
end

Then(/^the branch '(.*)' should be (watched|unwatched)$/) do |branch, status|
  expect(Branch.find_by(name: branch).watched).to eq (status == 'watched')
end
