@javascript
Feature: As a user
  I want to see all commit info

Scenario:
  Given I have the following commits
  | Sha | Message  | Committer  | Committed At        |
  | 010a| message 1| committer 1| 2015-12-12 01:12:00 |
  And the commit with sha '010a' has some file changes
  | filename       | patch |
  | dir/file.ext   | @@ -10,5 +10,5 @@\nline 1\nline 2\nline 3\n+line 4\n-line 5\nline 6 |
  And I am on the commits page
  When I click on 'message 1'
  And I click on line change with text 'line 4'
  And I wait for ajax to finish
  Then I should see comment dialog
