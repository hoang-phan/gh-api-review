Given(/^I have the following commits$/) do |table|
  Commit.import(table.hashes.map do |row|
    build(:commit,
      sha: row['Sha'],
      message: row['Message'],
      committer: row['Committer'],
      committed_at: row['Committed At']
    )
  end)
end

Then(/^I should see all the following commits$/) do |table|
  commit_items = all('.commit-item')
  table.hashes.each do |row|
    content_block = commit_items[row['Position'].to_i]
    expect(content_block).to have_content(row['Title'])
    expect(content_block).to have_content(row['Description'])
  end
end

Given(/^the commit with sha '(.*)' has some file changes$/) do |sha, table|
  commit = Commit.find_by_sha(sha)
  FileChange.import(table.hashes.map do |row|
    commit.file_changes.build(filename: row['filename'], patch: row['patch'], line_changes: PatchHelper.build_patch(row['patch']))
  end)
end

Given(/^the commit with sha '(.*)' has some comments$/) do |sha, table|
  commit = Commit.find_by_sha(sha)
  Comment.import(table.hashes.map do |row|
    commit.comments.build(row)
  end)
end

Then(/^I should see comment '(.*)' of user '(.*)' on line (.*) of file '(.*)'$/) do |body, user, line, filename|
  line_comment = find('.file-change', text: filename).all(".line-change[data-line='#{line}'] .comments").last
  expect(line_comment).to have_content(user)
  expect(line_comment).to have_content(body)
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
      'message' => 'message'
    },
    'committer' => {
      'login' => 'committer'
    }
  }

  @commits_result2 = {
    'sha' => '88383',
    'commit' => {
      'author' => {
        'date' => Date.today
      },
      'message' => 'message',
      'committer' => {
        'name' => 'committer2'
      }
    }
  }

  @commit_json = JSON(File.read("#{Rails.root}/spec/fixtures/commit.json"))
  @comments_json = JSON(File.read("#{Rails.root}/spec/fixtures/comments.json"))
  @branches_json = JSON(File.read("#{Rails.root}/spec/fixtures/branches.json"))
  allow(@client).to receive(:commit).with(repo, anything, per_page: GITHUB_ENV['results_per_page']).and_return(@commit_json)
  allow(@client).to receive(:commit_comments).with(repo, anything, per_page: GITHUB_ENV['results_per_page']).and_return(@comments_json)
  allow(@client).to receive(:branches).with(repo, page: 1, per_page: GITHUB_ENV['results_per_page']).and_return(@branches_json)
  allow(@client).to receive(:branches).with(repo, page: 2, per_page: GITHUB_ENV['results_per_page'])
  allow(@client).to receive(:commits_since).with(repo, anything, anything).and_return([@commits_result, @commits_result2])
  $client = @client
end

Then(/^the commits of repository '(.*)' should be reloaded$/) do |repo|
  repository = Repository.find_by(full_name: repo)
  commit = repository.commits.find_by(sha: @commits_result['sha'], message: @commits_result['commit']['message'], committer: @commits_result['committer']['login'])
  expect(commit).to be_present
  expect(commit.file_changes.pluck(:patch)).to match_array @commit_json['files'].map { |file| file['patch'] }
  expect(commit.comments.pluck(:external_id)).to match_array @comments_json.map { |json| json['id'] }
  expect(repository.commits).to be_exists sha: @commits_result2['sha'], message: @commits_result2['commit']['message'], committer: @commits_result2['commit']['committer']['name']
end

When(/^I click on last line change with text '(.*)'$/) do |line|
  wait_until { page.all('.line', text: line).present? }
  all('.line', text: line).last.click
end

Then(/^I should see comment dialog on line (\d+)$/) do |ln|
  expect(page).to have_css ".line-change[data-line='#{ln}'] .comment-form"
  expect(page).to have_css "input[name='line'][value='#{ln}']", visible: false
end

Then(/^I should not see comment dialog on line (\d+)$/) do |ln|
  expect(page).not_to have_css ".line-change[data-line='#{ln}'] .comment-form"
  expect(page).not_to have_css "input[name='line'][value='#{ln}']", visible: false
end

Then(/^I should successfully commented with '(.*)' on line (\d+) of the file '(.*)' of commit '(.*)'$/) do |comment, pos, file, sha|
  @client = double
  expect(@client).to receive(:create_commit_comment).with(anything, sha, comment, file, nil, pos.to_i)
  $client = @client
end

Given(/^there are some snippets$/) do |table|
  snippets = table.hashes.each_with_object({}) do |row, result|
    result[row['key']] = row['value']
  end
  SnippetsController
  stub_const('SnippetsController::ALL_SNIPPETS', snippets)
end

When(/^I choose '(.*)' from autocomplete$/) do |option|
  page.execute_script("$([name='#{name}']).trigger('keydown')")
  @field.native.send_keys :return
end

When(/^I click '(.*)' within comment dialog on line (\d+)$/) do |btn, ln|
  within ".line-change[data-line='#{ln}'] .comment-form" do
    click_on btn
  end
end


