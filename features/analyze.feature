Feature: As a user
  I want to analyze a commit

Background:
  Given I have the following commits
  | Sha | Message  | Committer  | Committed At        |
  | 010a| message 1| committer 1| 2015-12-12 01:12:00 |
  | bf22| message 2| committer 2| 2015-12-12 01:12:33 |
  And the commit with sha '010a' has some file changes
  | filename       | patch                                                             |
  | dir/file.ext   | @@ -10,4 +10,4 @@line 1\nline 2\nline 3\n+line 4\n-line 5\nline 6 |
  And the commit with sha 'bf22' has some file changes
  | filename       | patch                                                             |
  | dir/file.ext   | @@ -1,1 +1,2 @@line 7\nline 9\n+line 8 |
  And there are some rules
  | regex  | lang | name   | offset |
  | line 2 | ext  | rule 1 |        |
  | ne 2   | ext  | rule 2 |        |
  | line 8 | ext  | rule 3 | 1      |
  And there are some random comments for rules
  | rule  | suggestions       |
  | rule 1| suggest1,suggest3 |
  | rule 2| suggest2          |
  | rule 3| suggest4          |
  And the sample of rule 'rule 1' is 'suggest1'
  And I am on the commits page
  When I click on 'Analyze all commits'
  And I wait for 'Analyzer' workers to finish
  Then I should see 'Request sent. Please reload page later'
  
Scenario: Autosuggest
  When I click on 'message 1'
  Then I should see comment dialog on line 1
  And I should see dropdown 'rules' with following options
  | rule 1 |
  | rule 2 |
  And I should see 'suggest1' in 'body' field

Scenario: Autosuggest for line with offset
  When I click on 'message 2' 
  Then I should see comment dialog on line 1

@javascript
Scenario: Change rules for suggestions
  When I click on 'message 1'
  When I select 'rule 2' from dropdown 'rules'
  Then I should see 'suggest2' on 'body' field
  And I should not see 'suggest1' in 'body' field

@javascript
Scenario: Randomize comments
  When I click on 'message 1'
  When I click on 'Random comment'
  Then I should not see 'suggest1' in 'body' field
  And I should see 'suggest3' in 'body' field
  When I click on 'Random comment'
  Then I should see 'suggest1' in 'body' field