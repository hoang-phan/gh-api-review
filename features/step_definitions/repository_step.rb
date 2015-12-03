Given(/^there are some repositories on remote server$/) do
  @repositories = JSON(File.read("#{Rails.root}/spec/fixtures/repos.json"))
  @branch_name = 'dev'
  $client = double(repositories: @repositories)
  allow($client).to receive(:branches).and_return([{ 'name' => @branch_name }])
end

Then(/^the local repositories should be reloaded$/) do
  @repositories.each do |repo|
    repository = Repository.find_by(full_name: repo['full_name'])
    expect(repository).to be_present
    expect(repository.branches).to be_exists(name: @branch_name)
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





