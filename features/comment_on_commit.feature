@javascript
Feature: As a user
  I want to see all commit info

Scenario:
  Given I have the following commits
  | Sha | Message  | Committer  | Committed At        |
  | 010a| message 1| committer 1| 2015-12-12 01:12:00 |
  And the commit with sha '010a' has some file changes
  | filename       | patch                                                             |
  | dir/file.ext   | @@ -10,5 +10,5 @@line 1\nline 2\nline 3\n+line 4\n-line 5\nline 6 |
  And I am on the commits page
  When I click on 'message 1'
  And I click on last line change with text 'line 1'
  And I wait for ajax to finish
  Then I should see comment dialog on line 0
  And I should successfully commented with 'My Content Body' on line 0 of the file 'dir/file.ext' of commit '010a'
  When I fill in 'body' with 'My Content Body'
  And I click on 'Add comment'
  Then I should see all the following
  | Content                |
  | Successfully commented |
