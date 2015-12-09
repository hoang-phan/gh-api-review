Given(/^I have the following commits$/) do |table|
  table.hashes.each do |row|
    create(:commit,
      sha: row['Sha'],
      message: row['Message'],
      committer: row['Committer'],
      committed_at: row['Committed At']
    )
  end
end

Then(/^I should see all the following commits$/) do |table|
  table.hashes.each do |row|
    content_block = find('.commit-item', text: row['Title'])
    expect(content_block).to have_content(row['Description'])
  end
end

Given(/^the commit with sha '(.*)' has some file changes$/) do |sha, table|
  commit = Commit.find_by_sha(sha)
  table.hashes.each do |row|
    commit.file_changes.create(filename: row['filename'], patch: row['patch'])
  end
end

Then(/^the following lines are (.*)$/) do |status, table|
  table.hashes.each do |row|
    expect(page).to have_css(".#{status}-line", text: row['Line'])
  end
end

Given(/^I have some commits of repository '(.*)' on Github$/) do |repo|
  @client = double
  @commits_result = {
    'sha' => '12321afdfa',
    'commit' => {
      'author' => {
        'date' => Date.today
      },
      'message' => 'message',
      'committer' => {
        'login' => 'committer'
      }
    }
  }

  @commit_json = JSON(File.read("#{Rails.root}/spec/fixtures/commit.json"))
  @branches_json = JSON(File.read("#{Rails.root}/spec/fixtures/branches.json"))
  allow(@client).to receive(:commit).with(repo, anything, per_page: GITHUB_ENV['results_per_page']).and_return(@commit_json)
  allow(@client).to receive(:branches).with(repo, page: 1, per_page: GITHUB_ENV['results_per_page']).and_return(@branches_json)
  allow(@client).to receive(:branches).with(repo, page: 2, per_page: GITHUB_ENV['results_per_page'])
  allow(@client).to receive(:commits_since).with(repo, anything, anything).and_return([@commits_result])
  $client = @client
end

Then(/^the commits of repository '(.*)' should be reloaded$/) do |repo|
  repository = Repository.find_by(full_name: repo)
  commit = repository.commits.find_by(sha: @commits_result['sha'], message: @commits_result['commit']['message'], committer: @commits_result['commit']['committer']['login'])
  expect(commit).to be_present
  expect(commit.file_changes.pluck(:patch)).to match_array ["\n...\n<span>   52</span> | <span>   52</span> | <span class=\"unchanged-line\"> gem &#39;redis-rails&#39;</span>\n<span>   53</span> | <span>   53</span> | <span class=\"unchanged-line\"> </span>\n<span>   54</span> | <span>   54</span> | <span class=\"unchanged-line\"> gem &#39;stripe&#39;</span>\n<span>   55</span> | <span>   55</span> | <span class=\"unchanged-line\"> </span>\n<span>     </span> | <span>   56</span> | <span class=\"added-line\">+gem &#39;twilio-ruby&#39;</span>\n<span>     </span> | <span>   57</span> | <span class=\"added-line\">+</span>\n<span>   56</span> | <span>   58</span> | <span class=\"unchanged-line\"> group :development, :test do</span>\n<span>   57</span> | <span>   59</span> | <span class=\"unchanged-line\">   gem &#39;byebug&#39;, &#39;~&gt; 8.0.0&#39;</span>\n<span>   58</span> | <span>   60</span> | <span class=\"unchanged-line\">   gem &#39;rspec-rails&#39;, &#39;~&gt; 3.3.3&#39;</span>", "\n...\n<span>   10</span> | <span>   10</span> | <span class=\"unchanged-line\"></span>\n<span>   11</span> | <span>   11</span> | <span class=\"unchanged-line\">   it { should validate_presence_of(:telephone_number) }</span>\n<span>   12</span> | <span>   12</span> | <span class=\"unchanged-line\">   it { should validate_presence_of(:country) }</span>\n<span>   13</span> | <span>   13</span> | <span class=\"unchanged-line\">   it { should validate_presence_of(:postcode) }</span>\n<span>     </span> | <span>   14</span> | <span class=\"added-line\">+</span>\n<span>   14</span> | <span>   15</span> | <span class=\"unchanged-line\"> end</span>"]
end
