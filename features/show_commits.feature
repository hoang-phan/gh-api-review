@time_freeze
Feature: As a user
  I want to see all commits

Scenario:
  Given now is '2015-12-12 01:12:20 UTC'
  And I have the following commits
  | Message  | Committer  | Committed At        |
  | message 1| commiter 1 | 2015-12-12 01:11:20 |
  | message 2| commiter 2 | 2015-12-12 01:12:19 |
  | message 3| commiter 3 | 2015-12-12 00:10:00 |
  | message 4| commiter 4 | 2015-12-10 00:10:00 |
  And I am on the commits page
  Then I should see all the following commits
  | Title     | Description                                    | Position |
  | message 2 | Committed by commiter 2 less than a minute ago |    0     |
  | message 1 | Committed by commiter 1 1 minute ago           |    1     |
  | message 3 | Committed by commiter 3 about 1 hour ago       |    2     |
  | message 4 | Committed by commiter 4 2 days ago             |    3     |

  And I should see link 'Repositories' to repositories page
