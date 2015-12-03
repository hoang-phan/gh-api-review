Given(/^there are some branches of repository on remote server$/) do
  @branches = JSON(File.read("#{Rails.root}/spec/fixtures/branches.json"))
  $client = double(branches: @branches)
end

When(/^I wait for the fetch branches worker$/) do
  BranchesFetch.drain
end

Then(/^the local branches of repository '(.*)' should be reloaded$/) do |repo|
  repository = Repository.find_by(full_name: repo)
  @branches.each do |branch|
    expect(repository.branches).to be_exists(name: branch['name'])
  end
end
