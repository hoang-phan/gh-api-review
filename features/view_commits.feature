Feature: As a user
  I want to see all commit info

Scenario:
  Given I have the following commits
  | Sha | Message  | Committer  | Committed At        |
  | 010a| message 1| committer 1| 2015-12-12 01:12:00 |
  And the commit with sha '010a' has some file changes
  | filename       | patch |
  | dir/file.ext   | @@ -10,5 +10,5 @@\nline 1\nline 2\nline 3\n+line 4\n-line 5\nline 6 |
  And the commit with sha '010a' has some comments
  | filename       | line | body    | commented_at        | user  |
  | dir/file.ext   | 3    | my body | 2015-12-12 01:22:00 | user1 |
  And I am on the commits page
  When I click on 'message 1'
  Then I should see all the following
  | Content             |
  | message 1           |
  | Author committer 1  |
  And the following lines are unchanged
  | Line   |
  | line 1 |
  | line 2 |
  | line 3 |
  And the following lines are added
  | Line   |
  | line 4 |
  And the following lines are removed
  | Line   |
  | line 5 |
  And I should see comment 'my body' of user 'user1' on line 3 of file 'dir/file.ext'