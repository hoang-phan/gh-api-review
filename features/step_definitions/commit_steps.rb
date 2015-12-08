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
