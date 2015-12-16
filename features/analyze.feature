@javascript
Feature: As a user
  I want to analyze a commit

Background:
  Given I have the following commits
  | Sha | Message  | Committer  | Committed At        |
  | 010a| message 1| committer 1| 2015-12-12 01:12:00 |
  And the commit with sha '010a' has some file changes
  | filename       | patch                                                             |
  | dir/file.ext   | @@ -10,5 +10,5 @@line 1\nline 2\nline 3\n+line 4\n-line 5\nline 6 |
  And there are some rules
  | regex  | lang | name   |
  | line 1 | ext  | rule 1 |
  | ne 1   | ext  | rule 2 |
  And there are some random comments for rules
  | rule  | suggestions       |
  | rule 1| suggest1,suggest3 |
  | rule 2| suggest2          |
  And the sample of rule 'rule 1' is 'suggest1'
  And I am on the commits page
  When I click on 'Analyze all commits'
  And I wait for 'Analyzer' workers to finish
  Then I should see 'Request sent. Please reload page later'
  When I click on 'message 1'

Scenario: Autosuggest
  Then I should see comment dialog on line 0
  And I should see dropdown 'rules' with following options
  | rule 1 |
  | rule 2 |
  And I should see 'suggest1' in 'body' field

Scenario: Change rules for suggestions
  When I select 'rule 2' from dropdown 'rules'
  Then I should see 'suggest2' on 'body' field
  And I should not see 'suggest1' in 'body' field

Scenario: Randomize comments
  When I click on 'Random comment'
  Then I should not see 'suggest1' in 'body' field
  And I should see 'suggest3' in 'body' field