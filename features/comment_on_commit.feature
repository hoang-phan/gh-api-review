@javascript
Feature: As a user
  I want to comment on a commit commit info

Background:
  Given I have the following commits
  | Sha | Message  | Committer  | Committed At        |
  | 010a| message 1| committer 1| 2015-12-12 01:12:00 |
  And the commit with sha '010a' has some file changes
  | filename       | patch                                                             |
  | dir/file.ext   | @@ -10,5 +10,5 @@line 1\nline 2\nline 3\n+line 4\n-line 5\nline 6 |
  Given there are some snippets
  | key  | value                      |
  | key1 | content1[[cursor]]content2 |
  And I am on the commits page

Scenario: Autocomplete snippet
  When I click on 'message 1'
  And I click on last line change with text 'line 1'
  And I wait for ajax to finish
  Then I should see comment dialog on line 0
  When I focus first field with name 'body'
  And I enter 'key1'
  And I wait for ajax to finish
  And I choose 'key1' from autocomplete
  And I press tab
  And I press tab
  Then I should see 'content1    content2' on 'body' field

Scenario: Comment on commit
  When I click on 'message 1'
  And I click on last line change with text 'line 1'
  And I wait for ajax to finish
  And I fill in 'body' with 'My content'
  Then I should successfully commented with 'My content' on line 0 of the file 'dir/file.ext' of commit '010a'
  And I click on 'Add comment'
  Then I should see 'Successfully commented'

Scenario: Cannot add 2 comment boxes on the same line
  When I click on 'message 1'
  And I click on last line change with text 'line 1'
  And I wait for ajax to finish
  And I click on last line change with text 'line 1'
  Then no ajax call should be made

Scenario: Can add 2 comment boxes on 2 different lines
  When I click on 'message 1'
  And I click on last line change with text 'line 1'
  And I click on last line change with text 'line 2'
  And I wait for ajax to finish
  Then I should see comment dialog on line 0
  And I should see comment dialog on line 1

Scenario: Remove a dialog
  When I click on 'message 1'
  And I click on last line change with text 'line 1'
  And I click on last line change with text 'line 2'
  And I wait for ajax to finish
  And I click 'Cancel' within comment dialog on line 0  
  Then I should not see comment dialog on line 0
  And I should see comment dialog on line 1
