Given(/^I have the following commits$/) do |table|
  table.hashes.each do |row|
    create(:commit,
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
